import { ContractName, DeployedContracts, DeploymentTag, deployProxy } from '../utils/Deploy';
import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';

const func: DeployFunction = async ({ getNamedAccounts }: HardhatRuntimeEnvironment) => {
    const { deployer } = await getNamedAccounts();

    const bntGovernance = await DeployedContracts.BNTGovernance.deployed();
    const vbntGovernance = await DeployedContracts.VBNTGovernance.deployed();

    await deployProxy({
        name: ContractName.ExternalRewardsVault,
        from: deployer,
        args: [bntGovernance.address, vbntGovernance.address]
    });

    return true;
};

func.id = DeploymentTag.ExternalRewardsVaultV1;
func.dependencies = [DeploymentTag.V2, DeploymentTag.ProxyAdmin];
func.tags = [DeploymentTag.V3, DeploymentTag.ExternalRewardsVaultV1];

export default func;
