//! This module contains functions and constructs related to elliptic curve operations on the
//! secp256k1 curve.

use starknet::{SyscallResult, SyscallResultTrait, secp256_trait::{Secp256Trait, Secp256PointTrait}
};
use option::OptionTrait;
use secp256_trait::{secp256k1_ec_new_syscall, ...}; //importar otras funciones y borrar el resto

#[derive(Copy, Drop)]
extern type Secp256K1EcPoint;

/// Creates a secp256k1 EC point from the given x and y coordinates.
/// Returns None if the given coordinates do not correspond to a point on the curve.
extern fn secp256k1_ec_new_syscall(
    x: u256, y: u256
) -> SyscallResult<Option<Secp256K1EcPoint>> implicits(GasBuiltin, System) nopanic;

/// Computes the addition of secp256k1 EC points `p0 + p1`.
extern fn secp256k1_ec_add_syscall(
    p0: Secp256K1EcPoint, p1: Secp256K1EcPoint
) -> SyscallResult<Secp256K1EcPoint> implicits(GasBuiltin, System) nopanic;

/// Computes the product of a secp256k1 EC point `p` by the given scalar `m`.
extern fn secp256k1_ec_mul_syscall(
    p: Secp256K1EcPoint, m: u256
) -> SyscallResult<Secp256K1EcPoint> implicits(GasBuiltin, System) nopanic;

/// Computes the point on the secp256k1 curve that matches the given `x` coordinate, if such exists.
/// Out of the two possible y's, chooses according to `y_parity`.
extern fn secp256k1_ec_get_point_from_x_syscall(
    x: u256, y_parity: bool
) -> SyscallResult<Option<Secp256K1EcPoint>> implicits(GasBuiltin, System) nopanic;

/// Creates the generator point of the secp256k1 curve.
fn get_generator_point() -> Secp256K1EcPoint {
    secp256k1_ec_new_syscall(
        u256 { high: 0x79be667ef9dcbbac55a06295ce870b07, low: 0x029bfcdb2dce28d959f2815b16f81798 },
        u256 { high: 0x483ada7726a3c4655da4fbfc0e1108a8, low: 0xfd17b448a68554199c47d08ffb10d4b8 }
    )
        .unwrap_syscall()
        .unwrap()
}

fn get_X_point() -> Secp256K1EcPoint {
    secp256k1_ec_new_syscall(
        u256 { high: 0x243cb3be9e40c561a4bf49215ddc6950, low: 0x51c2cd17e50859e1eb142d12f01e4be7 },
        u256 { high: 0xc0f74cca763e491f25d2ccb2999c772a, low: 0x273ce9ae448b455d8ae6050da528c982 }
    )
        .unwrap_syscall()
        .unwrap()
}

fn get_R_point() -> Secp256K1EcPoint {
    secp256k1_ec_new_syscall(
        u256 { high: 0x9ccfbc6c71bc780800cf32a833a6472b, low: 0xd7f1d7c66914ebb71e74ef0ae10ea485 },
        u256 { high: 0xbc71c90dcfa06a98f6c80dbcde56a803, low: 0xa2637811a97636d4b8bd6d5af1a23b97 }
    )
        .unwrap_syscall()
        .unwrap()
}

fn main () {
    let generator_point = get_generator_point();
    let s_scalar = u256 { high: 0x7562e5757a05e22953aec696f787d82c, low: 0x77a69980d9beb47af85d0f45dc963dda };  
    let sG = secp256k1_ec_mul_syscall(generator_point, s_scalar).unwrap_syscall();

    let X_point = get_X_point();
    let e_scalar = u256 { high: 0x8778f5e37df35b407d81055e8088133a, low: 0xa848f467b80972b74e76f8395b8e1b37 };  
    let eX = secp256k1_ec_mul_syscall(X_point, e_scalar).unwrap_syscall();

    let R_point = get_R_point();
    let R_eX = secp256k1_ec_add_syscall(R_point, eX).unwrap_syscall();

    let (x,y) = secp256k1_get_xy_syscall(sG);
    let (x2,y2) = secp256k1_get_xy_syscall(R_eX);
    if x != x2 || y != y2 {
        panic_with_felt252('error, sG is equal to R_eX')
    }
    //assert(sG != R_eX, 'error, sG is equal to R_eX');
}
