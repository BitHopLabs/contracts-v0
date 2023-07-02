import {BigNumber} from 'ethers';
import {murmurHash, objectHash} from "ohash";

export function genOrderId(srcChain: number, dstChain: number) {
    const time = Math.floor(new Date(new Date().getTime() + 24 * 60 * 60 * 1000).getTime() / 1000);
    const num = Math.random();
    const nonce = genNonce({time, srcChain, dstChain, num});
    return BigNumber.from(2)
        .pow(BigNumber.from(96))
        .mul(BigNumber.from(nonce))
        .add(
            //(time << 64)
            BigNumber.from(2).pow(BigNumber.from(64)).mul(BigNumber.from(time)),
        )
        .add(
            //(dstChain << 32)
            BigNumber.from(2).pow(BigNumber.from(32)).mul(BigNumber.from(srcChain)),
        )
        .add(
            // dstChain
            BigNumber.from(dstChain),
        );
}

export function genNonce(option: object) {
    return murmurHash(
        objectHash({
            ...option,
        }),
    );
}

