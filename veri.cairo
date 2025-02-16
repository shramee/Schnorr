use option::OptionTrait;
use starknet::secp256k1::{secp256k1_new_syscall, Secp256k1Point};
use starknet::secp256_trait::{Secp256Trait, Secp256PointTrait};
use starknet::{SyscallResult, SyscallResultTrait};

fn get_X_point() -> Secp256k1Point {
    secp256k1_new_syscall(
        0xf1d5bf4c699dc0e31ac0afe94071aa690bdfebe3f4de82d35ad49da2c59e6d26,
        0x6f0af800db9f5ae7f05237c7dbbede947ec88426dad0d94a0ff3c8be446d590a
    )
        .unwrap_syscall()
        .unwrap()
}

fn get_R_point() -> Secp256k1Point {
    secp256k1_new_syscall(
        0x267ee5176ab8b9822e49eaaa1b0c79ddc343900a5fcb78e9b03ec7d1e0719305,
        0x8450dd514a51a733e455be7d485f01338a08b2c6b3ade1e94f0fadd78923041f
    )
        .unwrap_syscall()
        .unwrap()
}

fn get_s() -> u256 {
    0x99b48df59941f617c26f4eb7cae3291f08a2fca1aebf54f9f24b973b60390f63
}

fn get_e() -> u256 {
    0x605921b06cdec3b8abadac8c6d8a42fccca7ab57e6c8b0c478dcaafa1b92a91a
}

#[test]
#[available_gas(200000)]
fn XXX() {
    let (sx, sy) = get_X_point().get_coordinates().unwrap_syscall();
    let (ux, uy) = get_X_point().get_coordinates().unwrap_syscall();

    assert(sx == ux, 'Wrong result');
    assert(sy == uy, 'Wrong result');
}
