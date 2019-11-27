#!/usr/bin/env node
import 'source-map-support/register';
import cdk = require('@aws-cdk/core');
import { CdkIamStack } from '../lib/cdk-iam-stack';

const app = new cdk.App();
new CdkIamStack(app, 'AwsCdkStack');
