'use strict';

import { module } from 'angular';
import UIROUTER_ANGULARJS from '@uirouter/angularjs';
import _ from 'lodash';

import { PIPELINE_CONFIG_ACTIONS } from './actions/pipelineConfigActions.module';
import { PipelineConfigService } from './services/PipelineConfigService';
import { PIPELINE_GRAPH_COMPONENT } from './graph/pipeline.graph.component';
import { PIPELINE_CONFIG_VIEW } from './pipelineConfigView';
import { PipelineTemplateV2Service } from './templates/v2/pipelineTemplateV2.service';
import { SECTION_FOOTER } from './pipelineConfigurer.html';

export const CORE_PIPELINE_CONFIG_PIPELINECONFIGURER_CONTROLLER = 'spinnaker.core.pipeline.config.pipelineConfigurer.controller';
export const name = CORE_PIPELINE_CONFIG_PIPELINECONFIGURER_CONTROLLER; // for backwards compatibility
