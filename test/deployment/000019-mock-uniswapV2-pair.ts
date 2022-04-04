import { MockUniswapV2Pair } from '../../components/Contracts';
import { ContractInstance, DeployedContracts, isMainnet } from '../../utils/Deploy';
import { describeDeployment } from '../helpers/Deploy';
import { expect } from 'chai';

describeDeployment(
    __filename,
    () => {
        let migration: MockUniswapV2Pair;

        beforeEach(async () => {
            migration = await DeployedContracts.MockUniswapV2Pair.deployed();
        });

        it('should deploy and configure the Uniswap v2 pair mock contract', async () => {
            expect(await migration.name()).to.eq(ContractInstance.MockUniswapV2Pair);
        });
    },
    () => isMainnet()
);
