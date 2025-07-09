CREATE INDEX `idx_act_idx_event_subscr` ON `act_ru_event_subscr` (`execution_id_`);

CREATE INDEX `idx_act_idx_event_subscr_config_` ON `act_ru_event_subscr` (`configuration_`);

CREATE INDEX `idx_result_id_type` ON `de_di_experiment_hit_log` (`result_id`, `type`);

CREATE INDEX `idx_act_idx_model_deployment` ON `act_re_model` (`deployment_id_`);

CREATE INDEX `idx_act_idx_model_source_extra` ON `act_re_model` (`editor_source_extra_value_id_`);

CREATE INDEX `idx_act_idx_model_source` ON `act_re_model` (`editor_source_value_id_`);

CREATE INDEX `idx_status_dsp_code` ON `de_di_dsp_field` (`status`, `dsp_code`);

CREATE INDEX `idx_act_uniq_procdef` ON `act_re_procdef` (`key_`, `version_`, `tenant_id_`);

CREATE INDEX `idx_act_idx_hi_procvar_name_type` ON `act_hi_varinst` (`name_`, `var_type_`);

CREATE INDEX `idx_act_idx_hi_procvar_task_id` ON `act_hi_varinst` (`task_id_`);

CREATE INDEX `idx_act_idx_hi_procvar_proc_inst` ON `act_hi_varinst` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_procdef_info_json` ON `act_procdef_info` (`info_json_id_`);

CREATE INDEX `idx_act_idx_procdef_info_proc` ON `act_procdef_info` (`proc_def_id_`);

CREATE INDEX `idx_de_di_field_used_i_field_code` ON `de_di_field_used` (`field_code`);

CREATE INDEX `idx_de_di_field_used_i_svc_id` ON `de_di_field_used` (`svc_id`);

CREATE INDEX `idx_act_idx_hi_detail_act_inst` ON `act_hi_detail` (`act_inst_id_`);

CREATE INDEX `idx_act_idx_hi_detail_name` ON `act_hi_detail` (`name_`);

CREATE INDEX `idx_act_idx_hi_detail_proc_inst` ON `act_hi_detail` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_hi_detail_task_id` ON `act_hi_detail` (`task_id_`);

CREATE INDEX `idx_act_idx_hi_detail_time` ON `act_hi_detail` (`time_`);

CREATE INDEX `idx_act_idx_bytear_depl` ON `act_ge_bytearray` (`deployment_id_`);

CREATE INDEX `idx_case_data_log_id_type` ON `de_di_case_hit_log` (`case_data_log_id`, `type`);

CREATE INDEX `idx_act_idx_variable_task_id` ON `act_ru_variable` (`task_id_`);

CREATE INDEX `idx_act_idx_var_procinst` ON `act_ru_variable` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_var_exe` ON `act_ru_variable` (`execution_id_`);

CREATE INDEX `idx_act_idx_var_bytearray` ON `act_ru_variable` (`bytearray_id_`);

CREATE INDEX `idx_act_idx_task_procdef` ON `act_ru_task` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_task_exec` ON `act_ru_task` (`execution_id_`);

CREATE INDEX `idx_act_idx_task_create` ON `act_ru_task` (`create_time_`);

CREATE INDEX `idx_act_idx_task_procinst` ON `act_ru_task` (`proc_inst_id_`);

CREATE INDEX `idx_execution_log_id_type` ON `de_di_hit_log` (`execution_log_id`, `type`);

CREATE INDEX `idx_element_id` ON `de_di_hit_log` (`element_id`);

CREATE INDEX `idx_act_idx_hi_act_inst_end` ON `act_hi_actinst` (`end_time_`);

CREATE INDEX `idx_act_idx_hi_act_inst_start` ON `act_hi_actinst` (`start_time_`);

CREATE INDEX `idx_act_idx_hi_act_inst_procinst` ON `act_hi_actinst` (`proc_inst_id_`, `act_id_`);

CREATE INDEX `idx_act_idx_hi_act_inst_exec` ON `act_hi_actinst` (`execution_id_`, `act_id_`);

CREATE INDEX `idx_act_idx_tjob_proc_def_id` ON `act_ru_timer_job` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_tjob_execution_id` ON `act_ru_timer_job` (`execution_id_`);

CREATE INDEX `idx_act_idx_tjob_proc_inst_id` ON `act_ru_timer_job` (`process_instance_id_`);

CREATE INDEX `idx_act_idx_tjob_exception` ON `act_ru_timer_job` (`exception_stack_id_`);

CREATE INDEX `idx_act_idx_job_proc_def_id` ON `act_ru_job` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_job_exception` ON `act_ru_job` (`exception_stack_id_`);

CREATE INDEX `idx_act_idx_job_proc_inst_id` ON `act_ru_job` (`process_instance_id_`);

CREATE INDEX `idx_act_idx_job_execution_id` ON `act_ru_job` (`execution_id_`);

CREATE INDEX `idx_act_idx_sjob_proc_inst_id` ON `act_ru_suspended_job` (`process_instance_id_`);

CREATE INDEX `idx_act_idx_sjob_proc_def_id` ON `act_ru_suspended_job` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_sjob_exception` ON `act_ru_suspended_job` (`exception_stack_id_`);

CREATE INDEX `idx_act_idx_sjob_execution_id` ON `act_ru_suspended_job` (`execution_id_`);

CREATE INDEX `idx_act_idx_exe_procinst` ON `act_ru_execution` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_exe_parent` ON `act_ru_execution` (`parent_id_`);

CREATE INDEX `idx_act_idx_exe_procdef` ON `act_ru_execution` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_exec_buskey` ON `act_ru_execution` (`business_key_`);

CREATE INDEX `idx_act_idx_exec_root` ON `act_ru_execution` (`root_proc_inst_id_`);

CREATE INDEX `idx_act_idx_exe_super` ON `act_ru_execution` (`super_exec_`);

CREATE INDEX `idx_act_idx_hi_ident_lnk_procinst` ON `act_hi_identitylink` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_hi_ident_lnk_task` ON `act_hi_identitylink` (`task_id_`);

CREATE INDEX `idx_act_idx_hi_ident_lnk_user` ON `act_hi_identitylink` (`user_id_`);

CREATE INDEX `idx_act_idx_athrz_procedef` ON `act_ru_identitylink` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_tskass_task` ON `act_ru_identitylink` (`task_id_`);

CREATE INDEX `idx_act_idx_ident_lnk_group` ON `act_ru_identitylink` (`group_id_`);

CREATE INDEX `idx_act_idx_idl_procinst` ON `act_ru_identitylink` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_ident_lnk_user` ON `act_ru_identitylink` (`user_id_`);

CREATE TABLE `f_table` (
  `f1` VARCHAR(2000),
  `f2` VARCHAR(2000),
  `f3` VARCHAR(2000),
  `f4` VARCHAR(2000),
  `f5` VARCHAR(2000),
  `f6` VARCHAR(2000),
  `f7` VARCHAR(2000),
  `f8` VARCHAR(2000),
  `f9` VARCHAR(2000),
  `f10` VARCHAR(2000),
  `f11` VARCHAR(2000),
  `f12` VARCHAR(2000),
  `f13` VARCHAR(2000),
  `f14` VARCHAR(2000),
  `f15` VARCHAR(2000),
  `f16` VARCHAR(2000),
  `f17` VARCHAR(2000),
  `f18` VARCHAR(2000),
  `f19` VARCHAR(2000),
  `f20` VARCHAR(2000),
  `f21` VARCHAR(2000),
  `f22` VARCHAR(2000),
  `f23` VARCHAR(2000),
  `f24` VARCHAR(2000),
  `f25` VARCHAR(2000),
  `f26` VARCHAR(2000),
  `f27` VARCHAR(2000),
  `f28` VARCHAR(2000),
  `f29` VARCHAR(2000),
  `f30` VARCHAR(2000)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX `idx_de_di_dsp_dict_i_f_id` ON `de_di_dsp_dict` (`f_id`);

CREATE INDEX `idx_idx_parent_id` ON `sys_menu_back` (`parent_id`);

CREATE INDEX `idx_act_idx_hi_pro_i_buskey` ON `act_hi_procinst` (`business_key_`);

CREATE INDEX `idx_act_idx_hi_pro_inst_end` ON `act_hi_procinst` (`end_time_`);

CREATE INDEX `idx_act_idx_djob_proc_def_id` ON `act_ru_deadletter_job` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_djob_execution_id` ON `act_ru_deadletter_job` (`execution_id_`);

CREATE INDEX `idx_act_idx_djob_exception` ON `act_ru_deadletter_job` (`exception_stack_id_`);

CREATE INDEX `idx_act_idx_djob_proc_inst_id` ON `act_ru_deadletter_job` (`process_instance_id_`);

CREATE INDEX `idx_act_idx_hi_task_inst_procinst` ON `act_hi_taskinst` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_event_subscr` ON `act_ru_event_subscr` (`execution_id_`);

CREATE INDEX `idx_act_idx_event_subscr_config_` ON `act_ru_event_subscr` (`configuration_`);

CREATE INDEX `idx_result_id_type` ON `de_di_experiment_hit_log` (`result_id`, `type`);

CREATE INDEX `idx_act_idx_model_deployment` ON `act_re_model` (`deployment_id_`);

CREATE INDEX `idx_act_idx_model_source_extra` ON `act_re_model` (`editor_source_extra_value_id_`);

CREATE INDEX `idx_act_idx_model_source` ON `act_re_model` (`editor_source_value_id_`);

CREATE INDEX `idx_status_dsp_code` ON `de_di_dsp_field` (`status`, `dsp_code`);

CREATE INDEX `idx_act_uniq_procdef` ON `act_re_procdef` (`key_`, `version_`, `tenant_id_`);

CREATE INDEX `idx_act_idx_hi_procvar_name_type` ON `act_hi_varinst` (`name_`, `var_type_`);

CREATE INDEX `idx_act_idx_hi_procvar_task_id` ON `act_hi_varinst` (`task_id_`);

CREATE INDEX `idx_act_idx_hi_procvar_proc_inst` ON `act_hi_varinst` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_procdef_info_json` ON `act_procdef_info` (`info_json_id_`);

CREATE INDEX `idx_act_idx_procdef_info_proc` ON `act_procdef_info` (`proc_def_id_`);

CREATE INDEX `idx_de_di_field_used_i_field_code` ON `de_di_field_used` (`field_code`);

CREATE INDEX `idx_de_di_field_used_i_svc_id` ON `de_di_field_used` (`svc_id`);

CREATE INDEX `idx_act_idx_hi_detail_act_inst` ON `act_hi_detail` (`act_inst_id_`);

CREATE INDEX `idx_act_idx_hi_detail_name` ON `act_hi_detail` (`name_`);

CREATE INDEX `idx_act_idx_hi_detail_proc_inst` ON `act_hi_detail` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_hi_detail_task_id` ON `act_hi_detail` (`task_id_`);

CREATE INDEX `idx_act_idx_hi_detail_time` ON `act_hi_detail` (`time_`);

CREATE INDEX `idx_act_idx_bytear_depl` ON `act_ge_bytearray` (`deployment_id_`);

CREATE INDEX `idx_case_data_log_id_type` ON `de_di_case_hit_log` (`case_data_log_id`, `type`);

CREATE INDEX `idx_act_idx_variable_task_id` ON `act_ru_variable` (`task_id_`);

CREATE INDEX `idx_act_idx_var_procinst` ON `act_ru_variable` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_var_exe` ON `act_ru_variable` (`execution_id_`);

CREATE INDEX `idx_act_idx_var_bytearray` ON `act_ru_variable` (`bytearray_id_`);

CREATE INDEX `idx_act_idx_task_procdef` ON `act_ru_task` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_task_exec` ON `act_ru_task` (`execution_id_`);

CREATE INDEX `idx_act_idx_task_create` ON `act_ru_task` (`create_time_`);

CREATE INDEX `idx_act_idx_task_procinst` ON `act_ru_task` (`proc_inst_id_`);

CREATE INDEX `idx_execution_log_id_type` ON `de_di_hit_log` (`execution_log_id`, `type`);

CREATE INDEX `idx_element_id` ON `de_di_hit_log` (`element_id`);

CREATE INDEX `idx_act_idx_hi_act_inst_end` ON `act_hi_actinst` (`end_time_`);

CREATE INDEX `idx_act_idx_hi_act_inst_start` ON `act_hi_actinst` (`start_time_`);

CREATE INDEX `idx_act_idx_hi_act_inst_procinst` ON `act_hi_actinst` (`proc_inst_id_`, `act_id_`);

CREATE INDEX `idx_act_idx_hi_act_inst_exec` ON `act_hi_actinst` (`execution_id_`, `act_id_`);

CREATE INDEX `idx_act_idx_tjob_proc_def_id` ON `act_ru_timer_job` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_tjob_execution_id` ON `act_ru_timer_job` (`execution_id_`);

CREATE INDEX `idx_act_idx_tjob_proc_inst_id` ON `act_ru_timer_job` (`process_instance_id_`);

CREATE INDEX `idx_act_idx_tjob_exception` ON `act_ru_timer_job` (`exception_stack_id_`);

CREATE INDEX `idx_act_idx_job_proc_def_id` ON `act_ru_job` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_job_exception` ON `act_ru_job` (`exception_stack_id_`);

CREATE INDEX `idx_act_idx_job_proc_inst_id` ON `act_ru_job` (`process_instance_id_`);

CREATE INDEX `idx_act_idx_job_execution_id` ON `act_ru_job` (`execution_id_`);

CREATE INDEX `idx_act_idx_sjob_proc_inst_id` ON `act_ru_suspended_job` (`process_instance_id_`);

CREATE INDEX `idx_act_idx_sjob_proc_def_id` ON `act_ru_suspended_job` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_sjob_exception` ON `act_ru_suspended_job` (`exception_stack_id_`);

CREATE INDEX `idx_act_idx_sjob_execution_id` ON `act_ru_suspended_job` (`execution_id_`);

CREATE INDEX `idx_act_idx_exe_procinst` ON `act_ru_execution` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_exe_parent` ON `act_ru_execution` (`parent_id_`);

CREATE INDEX `idx_act_idx_exe_procdef` ON `act_ru_execution` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_exec_buskey` ON `act_ru_execution` (`business_key_`);

CREATE INDEX `idx_act_idx_exec_root` ON `act_ru_execution` (`root_proc_inst_id_`);

CREATE INDEX `idx_act_idx_exe_super` ON `act_ru_execution` (`super_exec_`);

CREATE INDEX `idx_act_idx_hi_ident_lnk_procinst` ON `act_hi_identitylink` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_hi_ident_lnk_task` ON `act_hi_identitylink` (`task_id_`);

CREATE INDEX `idx_act_idx_hi_ident_lnk_user` ON `act_hi_identitylink` (`user_id_`);

CREATE INDEX `idx_act_idx_athrz_procedef` ON `act_ru_identitylink` (`proc_def_id_`);

CREATE INDEX `idx_act_idx_tskass_task` ON `act_ru_identitylink` (`task_id_`);

CREATE INDEX `idx_act_idx_ident_lnk_group` ON `act_ru_identitylink` (`group_id_`);

CREATE INDEX `idx_act_idx_idl_procinst` ON `act_ru_identitylink` (`proc_inst_id_`);

CREATE INDEX `idx_act_idx_ident_lnk_user` ON `act_ru_identitylink` (`user_id_`);

