import { defaultArgs } from './engine/types';
import { initEngineAndStartTask } from './engine/utils';
import { task, types } from 'hardhat/config';
import path from 'path';

export const PATH_TO_TASKS_FOLDER = 'migration/tasks';

export type migrateParamTask = defaultArgs;
task('migrate', 'Migrate the network')
    .addFlag('ledger', 'Signing from a ledger')
    .addParam('ledgerPath', 'Ledger path', "m/44'/60'/0'/0", types.string)
    .addParam('gasPrice', 'GasPrice in gwei', 0, types.int)
    .addParam('confirmationToWait', 'Number of confirmation to wait', 1, types.int)
    .addFlag('reset', 'Reset the migration data')
    .setAction(initEngineAndStartTask(path.join(PATH_TO_TASKS_FOLDER, 'migrate.ts')));

export type createMigrationParamTask = {
    migrationName: string;
};
task('create-migration', 'Create a migration file')
    .addPositionalParam('migrationName', 'Name of the migration name')
    .setAction(initEngineAndStartTask(path.join(PATH_TO_TASKS_FOLDER, 'createMigration.ts')));
