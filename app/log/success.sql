CREATE TABLE `df_field` (
  `id` BIGINT NOT NULL,
  `interface_id` BIGINT NOT NULL,
  `code` VARCHAR(200) NOT NULL,
  `name` VARCHAR(400) NOT NULL,
  `field_type` VARCHAR(40) NOT NULL,
  `param_type` VARCHAR(8) NOT NULL,
  `default_value` VARCHAR(200),
  `parent_id` BIGINT,
  `required_flag` VARCHAR(8),
  `is_encrypted` VARCHAR(8),
  `length` BIGINT,
  `accuracy` BIGINT,
  `remark` VARCHAR(1020),
  `order_num` BIGINT,
  `default_value_type` VARCHAR(8)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_event_subscr` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `event_type_` VARCHAR(510) NOT NULL,
  `event_name_` VARCHAR(510),
  `execution_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `activity_id_` VARCHAR(128),
  `configuration_` VARCHAR(510),
  `created_` DATETIME(6) NOT NULL,
  `proc_def_id_` VARCHAR(128),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_event_subscr` ADD CONSTRAINT `act_fk_event_exec` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

CREATE TABLE `de_di_experiment_hit_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `element_id` VARCHAR(64) COMMENT '命中组件id',
  `result_id` VARCHAR(64) COMMENT '执行记录编号',
  `name` VARCHAR(512) COMMENT '命中组件名称',
  `ord` BIGINT COMMENT '序号',
  `position` VARCHAR(32) COMMENT '命中位置行数（普通规则:1为正向命中,0为反向命中;决策表:单个数字代表命中行数;多维矩阵:多个数字以空格隔开，代表每个维度位置）',
  `type` VARCHAR(32) COMMENT '命中类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验结果命中明细';

CREATE TABLE `df_call_interface_log` (
  `id` DECIMAL(38,0) NOT NULL,
  `tran_no` VARCHAR(128),
  `interface_id` BIGINT,
  `url` LONGTEXT,
  `req` LONGTEXT,
  `res` LONGTEXT,
  `status` VARCHAR(8),
  `call_time` DATETIME(6),
  `resp_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_menu` (
  `menu_id` DECIMAL(38,0) NOT NULL COMMENT '菜单ID',
  `menu_name` VARCHAR(200) NOT NULL COMMENT '菜单名称',
  `parent_id` DECIMAL(38,0) COMMENT '父菜单ID',
  `order_num` BIGINT COMMENT '显示顺序',
  `path` VARCHAR(800) COMMENT '路由地址',
  `component` VARCHAR(1020) COMMENT '组件路径',
  `is_frame` BIGINT COMMENT '是否为外链（0是 1否）',
  `is_cache` BIGINT COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` CHAR(4) COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` CHAR(4) COMMENT '菜单状态（0显示 1隐藏）',
  `status` CHAR(4) COMMENT '菜单状态（0正常 1停用）',
  `perms` VARCHAR(400) COMMENT '权限标识',
  `icon` VARCHAR(400) COMMENT '菜单图标',
  `create_by` VARCHAR(256) COMMENT '创建者',
  `create_time` DATETIME(6) COMMENT '创建时间',
  `update_by` VARCHAR(256) COMMENT '更新者',
  `update_time` DATETIME(6) COMMENT '更新时间',
  `remark` VARCHAR(2000) COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

CREATE TABLE `de_di_dsp_link` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `src` VARCHAR(64) COMMENT '源节点',
  `dest` VARCHAR(64) COMMENT '目标节点',
  `c_script` LONGTEXT COMMENT '条件脚本',
  `c_view` LONGTEXT COMMENT '条件视图',
  `desc_info` VARCHAR(100) COMMENT '描述',
  `p_x` VARCHAR(32) COMMENT '位置x',
  `p_y` VARCHAR(32) COMMENT '位置y',
  `width` VARCHAR(32) COMMENT '宽',
  `height` VARCHAR(32) COMMENT '高',
  `s_p` VARCHAR(32) COMMENT '源连接点位置',
  `t_p` VARCHAR(32) COMMENT '目标连接点位置',
  `flow_id` VARCHAR(64) COMMENT '流程编号',
  `points` VARCHAR(256) COMMENT '连线轨迹',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_node` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(100) COMMENT '节点名称',
  `type` SMALLINT COMMENT '节点类型',
  `p_x` VARCHAR(32) COMMENT '位置x',
  `p_y` VARCHAR(32) COMMENT '位置y',
  `width` VARCHAR(32) COMMENT '宽',
  `height` VARCHAR(32) COMMENT '高',
  `flow_id` VARCHAR(64) COMMENT '流程编号',
  `ord` INT COMMENT '序号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_re_model` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `name_` VARCHAR(510),
  `key_` VARCHAR(510),
  `category_` VARCHAR(510),
  `create_time_` DATETIME(6),
  `last_update_time_` DATETIME(6),
  `version_` INT,
  `meta_info_` VARCHAR(4000),
  `deployment_id_` VARCHAR(128),
  `editor_source_value_id_` VARCHAR(128),
  `editor_source_extra_value_id_` VARCHAR(128),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_re_model` ADD CONSTRAINT `act_fk_model_source` FOREIGN KEY (`editor_source_value_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_re_model` ADD CONSTRAINT `act_fk_model_source_extra` FOREIGN KEY (`editor_source_extra_value_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_re_model` ADD CONSTRAINT `act_fk_model_deployment` FOREIGN KEY (`deployment_id_`) REFERENCES `act_re_deployment`(`id_`);

CREATE TABLE `de_di_decision_cate` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(100) COMMENT '名称',
  `p_id` VARCHAR(64) COMMENT '上级分类',
  `lib_id` VARCHAR(64) COMMENT '归属决策库',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_logininfor` (
  `info_id` DECIMAL(38,0) NOT NULL,
  `user_name` VARCHAR(200),
  `ipaddr` VARCHAR(200),
  `login_location` VARCHAR(1020),
  `browser` VARCHAR(200),
  `os` VARCHAR(200),
  `status` CHAR(4),
  `msg` VARCHAR(1020),
  `login_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_field` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '字段名称',
  `type` SMALLINT COMMENT '数据类型',
  `default_value` VARCHAR(1000) COMMENT '固定默认值',
  `empty_default_value` VARCHAR(1000) COMMENT '为空默认值',
  `status` SMALLINT COMMENT '状态',
  `p_id` VARCHAR(64) COMMENT '上级字段',
  `dsp_code` VARCHAR(64) COMMENT '调度编号',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_field_map` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `src_code` VARCHAR(512) COMMENT '源code',
  `dest_code` VARCHAR(128) COMMENT '目标code',
  `processor_id` VARCHAR(64) COMMENT '处理器编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_re_procdef` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `category_` VARCHAR(510),
  `name_` VARCHAR(510),
  `key_` VARCHAR(510) NOT NULL,
  `version_` INT NOT NULL,
  `deployment_id_` VARCHAR(128),
  `resource_name_` VARCHAR(4000),
  `dgrm_resource_name_` VARCHAR(4000),
  `description_` VARCHAR(4000),
  `has_start_form_key_` TINYINT,
  `has_graphical_notation_` TINYINT,
  `suspension_state_` INT,
  `tenant_id_` VARCHAR(510) DEFAULT '',
  `engine_version_` VARCHAR(510),
  `app_version_` INT,
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_internal_data_table` (
  `table_name` VARCHAR(128) NOT NULL COMMENT '表的名称',
  `engine` VARCHAR(510) COMMENT '表使用的存储引擎',
  `create_time` DATETIME COMMENT '表的创建时间',
  `update_time` DATETIME COMMENT '表的最后更新时间',
  `table_comment` LONGTEXT COMMENT '表的注释'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='表数据信息';

CREATE TABLE `sys_dict_type` (
  `dict_id` DECIMAL(38,0) NOT NULL,
  `dict_name` VARCHAR(400),
  `dict_type` VARCHAR(400),
  `status` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_black_white_list` (
  `id` BIGINT NOT NULL,
  `user_type` VARCHAR(8) NOT NULL,
  `list_type` VARCHAR(8) NOT NULL,
  `id_no` VARCHAR(80),
  `id_no_prefix` VARCHAR(40),
  `id_type` VARCHAR(80),
  `name` VARCHAR(200),
  `name_keyword` VARCHAR(200),
  `mobile` VARCHAR(80),
  `mobile_prefix` VARCHAR(40),
  `status` VARCHAR(8) NOT NULL,
  `effective_time` DATETIME(6),
  `expire_time` DATETIME(6),
  `scene_scope` VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_batch_execute` (
  `task_id` DECIMAL(20,0) NOT NULL,
  `task_name` VARCHAR(200) COMMENT '任务名称',
  `library_id` DECIMAL(20,0) COMMENT '指标库ID',
  `library_version` DECIMAL(3,1) COMMENT '指标库版本',
  `starting_method` VARCHAR(4) COMMENT '1-人工触发 2-定时任务',
  `job_id` DECIMAL(20,0) COMMENT '定时任务id',
  `cron` VARCHAR(60) COMMENT 'cron表达式',
  `input_param_source` VARCHAR(4) COMMENT '1-文件导入 2-内部数据库',
  `file_id` VARCHAR(128) COMMENT '文件ID',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='批量回溯';

CREATE TABLE `df_dept` (
  `dept_id` DECIMAL(38,0) NOT NULL,
  `parent_id` DECIMAL(38,0),
  `ancestors` VARCHAR(200),
  `dept_name` VARCHAR(120),
  `order_num` BIGINT,
  `leader` VARCHAR(80),
  `phone` VARCHAR(44),
  `email` VARCHAR(200),
  `status` CHAR(4),
  `del_flag` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_limitation_waring_log` (
  `id` BIGINT NOT NULL,
  `tran_no` VARCHAR(1020) NOT NULL,
  `field_id` BIGINT NOT NULL,
  `res` VARCHAR(1020),
  `create_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_user_post` (
  `user_id` DECIMAL(38,0) NOT NULL,
  `post_id` DECIMAL(38,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lsp_user_role` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键id',
  `role_id` DECIMAL(20,0) NOT NULL COMMENT '角色id',
  `user_id` DECIMAL(20,0) NOT NULL COMMENT '用户id',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色';

CREATE TABLE `act_hi_varinst` (
  `id_` VARCHAR(128) NOT NULL,
  `proc_inst_id_` VARCHAR(128),
  `execution_id_` VARCHAR(128),
  `task_id_` VARCHAR(128),
  `name_` VARCHAR(510) NOT NULL,
  `var_type_` VARCHAR(200),
  `rev_` INT,
  `bytearray_id_` VARCHAR(128),
  `double_` DECIMAL(38,10),
  `long_` DECIMAL(19,0),
  `text_` VARCHAR(4000),
  `text2_` VARCHAR(4000),
  `create_time_` DATETIME(6),
  `last_updated_time_` DATETIME(6),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_comment` (
  `id_` VARCHAR(128) NOT NULL,
  `type_` VARCHAR(510),
  `time_` DATETIME(6) NOT NULL,
  `user_id_` VARCHAR(510),
  `task_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `action_` VARCHAR(510),
  `message_` VARCHAR(4000),
  `full_msg_` LONGBLOB,
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_field` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '字段名称',
  `type` SMALLINT COMMENT '数据类型',
  `input` SMALLINT COMMENT '是否输入',
  `default_value` VARCHAR(1000) COMMENT '固定默认值',
  `empty_default_value` VARCHAR(1000) COMMENT '为空默认值',
  `status` SMALLINT COMMENT '状态',
  `p_id` VARCHAR(64) COMMENT '上级字段',
  `svc_def_code` VARCHAR(64) COMMENT '决策服务定义',
  `is_output` SMALLINT COMMENT '是否固定输出,0:是,1:否',
  `col_num` SMALLINT COMMENT '所占列数',
  `is_hidden` SMALLINT COMMENT '是否隐藏(0:否)',
  `is_lib_index` SMALLINT COMMENT '是否指标库指标,1:是,0:否',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_biz_param` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '参数编号',
  `name` VARCHAR(100) COMMENT '参数名称',
  `value` VARCHAR(512) COMMENT '值',
  `options` LONGTEXT COMMENT '选项',
  `type` SMALLINT COMMENT '字段类型',
  `org_no` VARCHAR(64) COMMENT '机构号',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务参数';

CREATE TABLE `de_di_experiment_data` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `data` LONGTEXT COMMENT '数据内容',
  `dataset_id` VARCHAR(64) COMMENT '数据集ID',
  `real_val` SMALLINT COMMENT '是否为坏样本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验数据';

CREATE TABLE `de_di_node` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(100) COMMENT '节点名称',
  `type` SMALLINT COMMENT '节点类型',
  `p_x` VARCHAR(32) COMMENT '位置x',
  `p_y` VARCHAR(32) COMMENT '位置y',
  `width` VARCHAR(32) COMMENT '宽',
  `height` VARCHAR(32) COMMENT '高',
  `flow_id` VARCHAR(64) COMMENT '流程编号',
  `pkg_id` VARCHAR(64) COMMENT '规则包',
  `model_code` VARCHAR(64) COMMENT '模型编号',
  `input` VARCHAR(128) COMMENT '入参映射中间遍历编号',
  `output` VARCHAR(128) COMMENT '出参映射中间遍历编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_execution_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '内部交易流水',
  `tran_no` VARCHAR(64) COMMENT '外部交易流水',
  `in_json` LONGTEXT COMMENT '输入json',
  `out_json` LONGTEXT COMMENT '输出json',
  `status` SMALLINT COMMENT '执行状态',
  `start_date` DATETIME COMMENT '开始时间',
  `time` DECIMAL(20,0) COMMENT '执行秒数',
  `svc_def_code` VARCHAR(64) COMMENT '服务编号',
  `version` INT COMMENT '版本',
  `org_no` VARCHAR(64) COMMENT '机构',
  `temp_json` LONGTEXT COMMENT '中间变量json',
  `scores_json` LONGTEXT COMMENT '评分json',
  `server_mark` VARCHAR(32) COMMENT '执行服务器ip',
  `prediction_rs` CHAR(2) COMMENT '预测结果',
  `desire_rs` CHAR(2) COMMENT '期望结果',
  `error_msg` VARCHAR(512) COMMENT '错误信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_role_dept` (
  `role_id` DECIMAL(38,0) NOT NULL,
  `dept_id` DECIMAL(38,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_experiment_sc_detail` (
  `condition_value` VARCHAR(256) COMMENT '命中条件',
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `index_code` VARCHAR(64) COMMENT '指标编号',
  `index_name` VARCHAR(512) COMMENT '指标名称',
  `item_id` VARCHAR(64) COMMENT '评分项id',
  `ord` BIGINT COMMENT '命中序号',
  `score` INT COMMENT '命中分值',
  `score_card_log_id` VARCHAR(64) COMMENT '评分卡日志id',
  `weight_score` INT COMMENT '命中权重分',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验评分卡执行明细';

CREATE TABLE `de_di_test_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `svc_id` VARCHAR(64) COMMENT '服务id',
  `test_time` DATETIME NOT NULL COMMENT '测试时间',
  `error_cnt` INT COMMENT '未通过案例数量',
  `message` LONGTEXT COMMENT '错误信息',
  `error_id` LONGTEXT COMMENT '未通过案例id',
  `case_status` SMALLINT COMMENT '案例测试日志状态',
  `org_no` VARCHAR(64) COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_procdef_info` (
  `id_` VARCHAR(128) NOT NULL,
  `proc_def_id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `info_json_id_` VARCHAR(128),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_procdef_info` ADD CONSTRAINT `act_fk_info_json_ba` FOREIGN KEY (`info_json_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_procdef_info` ADD CONSTRAINT `act_fk_info_procdef` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_field_used` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `field_code` VARCHAR(66),
  `entity_id` VARCHAR(64) COMMENT '关联实体主键',
  `type` SMALLINT COMMENT '关联类型',
  `svc_id` VARCHAR(64) COMMENT '决策服务主键',
  `svc_code` VARCHAR(64) COMMENT '决策服务编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_tmpl_svc_def_ref` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `rule_template_code` VARCHAR(64) COMMENT '规则模板主键',
  `svc_def_code` VARCHAR(64) COMMENT '服务模板主键',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_experiment_sc_log` (
  `result_id` VARCHAR(64) COMMENT '执行日志id',
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `score_card_id` VARCHAR(64) COMMENT '评分卡id',
  `total` INT COMMENT '总分',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验评分卡执行记录';

CREATE TABLE `df_fun_param` (
  `id` VARCHAR(128) NOT NULL,
  `code` VARCHAR(128),
  `name` VARCHAR(200),
  `ord` BIGINT NOT NULL,
  `pid` VARCHAR(128),
  `is_multi` BIGINT NOT NULL,
  `type` BIGINT NOT NULL,
  `options` LONGTEXT,
  `function_id` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_link` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `src` VARCHAR(64) COMMENT '源节点',
  `dest` VARCHAR(64) COMMENT '目标节点',
  `c_script` LONGTEXT,
  `c_view` LONGTEXT,
  `desc_info` VARCHAR(100) COMMENT '描述',
  `p_x` VARCHAR(32) COMMENT '位置x',
  `p_y` VARCHAR(32) COMMENT '位置y',
  `width` VARCHAR(32) COMMENT '宽',
  `height` VARCHAR(32) COMMENT '高',
  `s_p` VARCHAR(128) COMMENT '源连接点位置',
  `t_p` VARCHAR(128) COMMENT '目标连接点位置',
  `flow_id` VARCHAR(64) COMMENT '流程编号',
  `points` VARCHAR(256) COMMENT '连线轨迹',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_config_process` (
  `id` VARCHAR(128) NOT NULL COMMENT '主键',
  `mark` VARCHAR(128) COMMENT '系统标识',
  `task_name` VARCHAR(64) COMMENT '任务名称',
  `task_type` SMALLINT COMMENT '任务类型',
  `exe_cycle` SMALLINT COMMENT '执行周期',
  `cycle_num` BIGINT COMMENT '周期数',
  `exe_script` LONGTEXT COMMENT '执行脚本',
  `pre_task` VARCHAR(64) COMMENT '前置任务',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置处理';

CREATE TABLE `de_di_name_list` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(256) COMMENT '名单名称',
  `type` SMALLINT COMMENT '名单类别',
  `org_no` VARCHAR(64) COMMENT '机构号',
  `cate_id` VARCHAR(64) COMMENT '分类id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='名单表';

CREATE TABLE `lsp_role` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '角色id',
  `role_name` VARCHAR(40) NOT NULL COMMENT '角色名称',
  `role_code` VARCHAR(40) COMMENT '角色编码',
  `description` VARCHAR(510) COMMENT '描述',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色';

CREATE TABLE `df_interface_header` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键ID',
  `interface_id` BIGINT NOT NULL COMMENT '接口id',
  `code` VARCHAR(510) NOT NULL COMMENT '代码',
  `name` VARCHAR(510) NOT NULL COMMENT '名称',
  `field_type` VARCHAR(20) NOT NULL COMMENT '字段类型',
  `default_value_type` VARCHAR(4) COMMENT '默认值类型',
  `default_value` VARCHAR(510) COMMENT '默认值',
  `remark` VARCHAR(510) COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_detail` (
  `id_` VARCHAR(128) NOT NULL,
  `type_` VARCHAR(510) NOT NULL,
  `proc_inst_id_` VARCHAR(128),
  `execution_id_` VARCHAR(128),
  `task_id_` VARCHAR(128),
  `act_inst_id_` VARCHAR(128),
  `name_` VARCHAR(510) NOT NULL,
  `var_type_` VARCHAR(128),
  `rev_` INT,
  `time_` DATETIME(6) NOT NULL,
  `bytearray_id_` VARCHAR(128),
  `double_` DECIMAL(38,10),
  `long_` DECIMAL(19,0),
  `text_` VARCHAR(4000),
  `text2_` VARCHAR(4000),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_derive_field_his` (
  `id` BIGINT NOT NULL,
  `old_id` BIGINT,
  `aggregate_function` VARCHAR(128),
  `code` VARCHAR(1020),
  `iterator` BIGINT,
  `name` VARCHAR(1020),
  `df_script` LONGTEXT,
  `df_json` LONGTEXT,
  `status` VARCHAR(8),
  `type` VARCHAR(8),
  `interface_id` BIGINT,
  `distinct_field` VARCHAR(144),
  `data_type` VARCHAR(8),
  `dept_id` VARCHAR(144),
  `html` LONGTEXT,
  `version` INT,
  `fields` VARCHAR(2048),
  `default_value` VARCHAR(400),
  `bits` INT,
  `distinct_field_id` BIGINT COMMENT '去重字段id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_fun` (
  `id` BIGINT NOT NULL,
  `code` VARCHAR(1020) NOT NULL,
  `name` VARCHAR(200),
  `status` BIGINT,
  `wr` BIGINT,
  `return_type` BIGINT,
  `return_option` LONGTEXT,
  `ord` DECIMAL(38,0) NOT NULL,
  `aggregate` VARCHAR(8),
  `system` VARCHAR(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_evt_log` (
  `log_nr_` DECIMAL(19,0) NOT NULL,
  `type_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `execution_id_` VARCHAR(128),
  `task_id_` VARCHAR(128),
  `time_stamp_` DATETIME(6) NOT NULL,
  `user_id_` VARCHAR(510),
  `data_` LONGBLOB,
  `lock_owner_` VARCHAR(510),
  `lock_time_` DATETIME(6),
  `is_processed_` TINYINT DEFAULT '0',
  PRIMARY KEY (`log_nr_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_job_log` (
  `job_log_id` DECIMAL(38,0) NOT NULL,
  `job_name` VARCHAR(256) NOT NULL,
  `job_group` VARCHAR(256) NOT NULL,
  `invoke_target` VARCHAR(2000) NOT NULL,
  `job_message` VARCHAR(2000),
  `status` CHAR(4),
  `exception_info` LONGTEXT,
  `create_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_param` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '参数编号',
  `name` VARCHAR(100) COMMENT '参数名称',
  `ord` SMALLINT COMMENT '序号',
  `pid` VARCHAR(64) COMMENT '上级编号',
  `is_multi` SMALLINT COMMENT '是否可多选',
  `type` SMALLINT COMMENT '字段类型',
  `options` LONGTEXT COMMENT '选项',
  `function_id` VARCHAR(64) COMMENT '函数编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_scheduled_task` (
  `id` VARCHAR(128) NOT NULL COMMENT '主键',
  `task_name` VARCHAR(128) COMMENT '任务名称',
  `svc_code` VARCHAR(128) COMMENT '决策服务编号',
  `org_no` VARCHAR(128) COMMENT '当前机构号',
  `version` INT COMMENT '版本号',
  `cron` VARCHAR(128) COMMENT '定时表达式',
  `status` SMALLINT COMMENT '任务状态',
  `input_file` VARCHAR(128) COMMENT '输入文件路径',
  `output_file` VARCHAR(128) COMMENT '输出文件路径',
  `input_script` LONGTEXT,
  `output_script` LONGTEXT,
  `owner` VARCHAR(128) COMMENT '处理器服务编号',
  `creator` VARCHAR(64) COMMENT '创建者',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lsp_organ` (
  `id` VARCHAR(104) NOT NULL COMMENT '机构id',
  `name` VARCHAR(100) NOT NULL COMMENT '机构名称',
  `parent_id` VARCHAR(104) COMMENT '上级机构id',
  `code` VARCHAR(60) COMMENT '机构号',
  `tree_path` VARCHAR(510) COMMENT '树结构',
  `sort_value` BIGINT COMMENT '排序',
  `address` VARCHAR(100) COMMENT '地址',
  `phone` VARCHAR(22) COMMENT '电话',
  `status` SMALLINT COMMENT '状态（1正常 0停用）',
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME,
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='组织机构';

CREATE TABLE `de_di_model_field` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '字段名称',
  `type` SMALLINT COMMENT '数据类型',
  `input` SMALLINT COMMENT '是否输入',
  `default_value` VARCHAR(1000) COMMENT '固定默认值',
  `empty_default_value` VARCHAR(1000) COMMENT '为空默认值',
  `status` SMALLINT COMMENT '状态',
  `p_id` VARCHAR(64) COMMENT '上级字段',
  `def_code` VARCHAR(64) COMMENT '服务定义',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型字段';

CREATE TABLE `de_di_decision_svc_def_cate` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(64) COMMENT '分类名称',
  `org_no` VARCHAR(64) COMMENT '机构号',
  `p_id` VARCHAR(64) COMMENT '上级分类id',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_link_src` (
  `id` BIGINT NOT NULL,
  `src_code` VARCHAR(400) NOT NULL,
  `src_name` VARCHAR(400) NOT NULL,
  `src_id` BIGINT,
  `type` VARCHAR(8) NOT NULL,
  `library_id` BIGINT NOT NULL,
  `create_time` DATETIME(6),
  `create_user` VARCHAR(120)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_score_card_detail` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `item_id` VARCHAR(64) COMMENT '评分项id',
  `index_code` VARCHAR(64) COMMENT '指标编号',
  `index_name` VARCHAR(512) COMMENT '指标名称',
  `ord` BIGINT COMMENT '命中序号',
  `condition_value` VARCHAR(256) COMMENT '命中条件',
  `score` INT COMMENT '命中分值',
  `weight_score` INT COMMENT '命中权重分',
  `score_card_log_id` VARCHAR(64) COMMENT '评分卡日志id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评分卡执行明细';

CREATE TABLE `de_di_decision_post` (
  `code` VARCHAR(64) NOT NULL COMMENT '岗位编号',
  `name` VARCHAR(128) COMMENT '岗位名称',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='策略岗位表';

CREATE TABLE `df_dict_data` (
  `dict_code` DECIMAL(38,0) NOT NULL COMMENT '字典编码',
  `dict_sort` BIGINT COMMENT '字典排序',
  `dict_label` VARCHAR(400) COMMENT '字典标签',
  `dict_value` VARCHAR(400) COMMENT '字典键值',
  `dict_type` VARCHAR(400) COMMENT '字典类型',
  `css_class` VARCHAR(400) COMMENT '样式属性（其他样式扩展）',
  `list_class` VARCHAR(400) COMMENT '表格回显样式',
  `is_default` CHAR(4) COMMENT '是否默认（Y是 N否）',
  `status` CHAR(4) COMMENT '状态（0正常 1停用）',
  `create_by` VARCHAR(256) COMMENT '创建者',
  `create_time` DATETIME(6) COMMENT '创建时间',
  `update_by` VARCHAR(256) COMMENT '更新者',
  `update_time` DATETIME(6) COMMENT '更新时间',
  `remark` VARCHAR(2000) COMMENT '备注',
  `filter` VARCHAR(1020) COMMENT '过滤条件',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典数据表';

CREATE TABLE `df_query_condition` (
  `id` VARCHAR(256) NOT NULL COMMENT '主键',
  `interface_id` DECIMAL(19,0) NOT NULL COMMENT '关联接口id',
  `field_name` VARCHAR(200) NOT NULL COMMENT '字段名',
  `operator` VARCHAR(40) COMMENT '运算符（= ,!= 或 <> 不等于 ,> ,< ,>= ,<= ,LIKE,NOT LIKE,IN,NOT IN）',
  `logic_operator` VARCHAR(16) DEFAULT 'AND' COMMENT '逻辑符（AND/OR）',
  `is_required` TINYINT DEFAULT '0' COMMENT '是否必填（1必填/0可选）',
  `order_num` BIGINT COMMENT '条件排序号',
  `parent_id` VARCHAR(256) NOT NULL DEFAULT '0' COMMENT '默认0',
  `function_expression` VARCHAR(400) COMMENT '字段函数表达式，如：to_date(?, \'yyyy-MM-dd\')',
  `function_params` VARCHAR(1020) COMMENT '函数参数，JSON格式，如：["create_time"]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='接口条件表';

CREATE TABLE `df_field_monitoring` (
  `id` BIGINT NOT NULL COMMENT '主键-自增',
  `field_id` BIGINT NOT NULL COMMENT '指标id',
  `app_code` VARCHAR(510) NOT NULL COMMENT 'appCode',
  `not_empty` CHAR(2) COMMENT '非空:Y-是,N-否',
  `special_values` VARCHAR(510) COMMENT '特殊值(逗号隔开)',
  `enums` VARCHAR(510) COMMENT '枚举(逗号隔开)',
  `status` CHAR(2) COMMENT '状态:1-有效,0-无效',
  `create_user` DECIMAL(20,0) COMMENT '创建人',
  `create_time` DATETIME COMMENT '创建时间',
  `update_user` DECIMAL(20,0) COMMENT '修改人',
  `update_time` DATETIME COMMENT '修改时间',
  `remark` VARCHAR(510) COMMENT '备注',
  `job_id` DECIMAL(20,0) COMMENT '任务id',
  `last_execution_time` DATETIME COMMENT '上次任务执行时间',
  `gap` BIGINT COMMENT '监控间隔(分钟)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标限制表';

CREATE TABLE `act_ge_bytearray` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `name_` VARCHAR(510),
  `deployment_id_` VARCHAR(128),
  `bytes_` LONGBLOB,
  `generated_` TINYINT,
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ge_bytearray` ADD CONSTRAINT `act_fk_bytearr_depl` FOREIGN KEY (`deployment_id_`) REFERENCES `act_re_deployment`(`id_`);

CREATE TABLE `de_di_case_hit_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `element_id` VARCHAR(64) COMMENT '命中组件id',
  `name` VARCHAR(512) COMMENT '命中组件名称',
  `ord` BIGINT COMMENT '组件序号',
  `type` VARCHAR(32) COMMENT '命中类型',
  `position` VARCHAR(32) COMMENT '命中位置行数',
  `case_data_log_id` VARCHAR(64) COMMENT '测试数据记录主键',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_model_dict` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '名称',
  `f_id` VARCHAR(64) COMMENT '所属字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型字典';

CREATE TABLE `act_ru_variable` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `type_` VARCHAR(510) NOT NULL,
  `name_` VARCHAR(510) NOT NULL,
  `execution_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `task_id_` VARCHAR(128),
  `bytearray_id_` VARCHAR(128),
  `double_` DECIMAL(38,10),
  `long_` DECIMAL(19,0),
  `text_` VARCHAR(4000),
  `text2_` VARCHAR(4000),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_variable` ADD CONSTRAINT `act_fk_var_bytearray` FOREIGN KEY (`bytearray_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_ru_variable` ADD CONSTRAINT `act_fk_var_exe` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_variable` ADD CONSTRAINT `act_fk_var_procinst` FOREIGN KEY (`proc_inst_id_`) REFERENCES `act_ru_execution`(`id_`);

CREATE TABLE `act_ru_task` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `execution_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `name_` VARCHAR(510),
  `business_key_` VARCHAR(255),
  `parent_task_id_` VARCHAR(128),
  `description_` VARCHAR(4000),
  `task_def_key_` VARCHAR(510),
  `owner_` VARCHAR(510),
  `assignee_` VARCHAR(510),
  `delegation_` VARCHAR(128),
  `priority_` INT,
  `create_time_` DATETIME(6),
  `due_date_` DATETIME(6),
  `category_` VARCHAR(510),
  `suspension_state_` INT,
  `tenant_id_` VARCHAR(510) DEFAULT '',
  `form_key_` VARCHAR(510),
  `claim_time_` DATETIME(6),
  `app_version_` INT,
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_task` ADD CONSTRAINT `act_fk_task_exe` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_task` ADD CONSTRAINT `act_fk_task_procinst` FOREIGN KEY (`proc_inst_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_task` ADD CONSTRAINT `act_fk_task_procdef` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_experiment_group` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(256) COMMENT '分组名称',
  `svc_id` VARCHAR(64) COMMENT '决策服务id',
  `dataset_id` VARCHAR(64) COMMENT '数据集id',
  `experiment_id` VARCHAR(64) COMMENT '实验id',
  `html` LONGTEXT COMMENT '坏样本计算规则页面',
  `script` LONGTEXT COMMENT '坏样本计算规则脚本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验分组';

CREATE TABLE `df_data_source` (
  `source_id` BIGINT NOT NULL,
  `source_type` VARCHAR(40) NOT NULL,
  `source_code` VARCHAR(256) NOT NULL,
  `source_name` VARCHAR(1020) NOT NULL,
  `status` VARCHAR(8) NOT NULL,
  `access_method` VARCHAR(1020) NOT NULL,
  `transaction_code` VARCHAR(1020) NOT NULL,
  `param_signature` VARCHAR(40),
  `data_encrypt` VARCHAR(40),
  `encrypt_encoding` VARCHAR(1020),
  `file_id` VARCHAR(256),
  `create_time` DATETIME(6),
  `create_by` VARCHAR(128),
  `update_time` DATETIME(6),
  `update_by` VARCHAR(128),
  `organ_id` VARCHAR(128),
  `organ_ids` VARCHAR(1020),
  `cache_enable` VARCHAR(10) DEFAULT 'N' COMMENT '缓存是否启用(Y:是,N:否)',
  `cache_duration` INT DEFAULT '-1' COMMENT '缓存时效(秒)',
  `timeout_enable` VARCHAR(10) DEFAULT 'N' COMMENT '数据超时是否启用(Y:是,N:否)',
  `timeout_duration` INT DEFAULT '-1' COMMENT '数据超时时间(毫秒)',
  `retry_count` INT DEFAULT '-1' COMMENT '重发次数',
  `retry_enable` VARCHAR(10) DEFAULT 'N' COMMENT '重发机制是否启用(Y:是,N:否)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_test_case` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `svc_code` VARCHAR(64) COMMENT '服务编号',
  `name` VARCHAR(256) COMMENT '案例名称',
  `data` LONGTEXT COMMENT '案例数据',
  `html` LONGTEXT COMMENT '验证规则页面',
  `script` LONGTEXT COMMENT '验证规则脚本',
  `create_time` DATETIME COMMENT '创建时间',
  `org_no` VARCHAR(64) COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lsp_menu` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '编号',
  `parent_id` DECIMAL(20,0) COMMENT '所属上级',
  `name` VARCHAR(40) NOT NULL COMMENT '名称',
  `url_perm` VARCHAR(128) COMMENT '接口权限标识',
  `type` SMALLINT NOT NULL COMMENT '类型(0:目录,1:菜单,2:按钮)',
  `path` VARCHAR(200) COMMENT '路由地址',
  `component` VARCHAR(200) COMMENT '组件路径',
  `perms` VARCHAR(200) COMMENT '权限标识',
  `icon` VARCHAR(200) COMMENT '图标',
  `sort_value` BIGINT COMMENT '排序',
  `status` SMALLINT COMMENT '状态(0:禁止,1:正常)',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）',
  `mark` VARCHAR(64) COMMENT '系统标识',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单表';

CREATE TABLE `de_di_case_data_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `tran_no` VARCHAR(64) COMMENT '外部交易流水',
  `in_json` LONGTEXT COMMENT '输入json',
  `out_json` LONGTEXT COMMENT '输出json',
  `status` SMALLINT COMMENT '执行状态',
  `start_date` DATETIME NOT NULL COMMENT '开始时间',
  `time` DECIMAL(20,0) COMMENT '执行秒数',
  `version` INT COMMENT '版本',
  `svc_def_code` VARCHAR(64) COMMENT '服务编号',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `data_source` SMALLINT COMMENT '案例数据来源',
  `test_log_id` VARCHAR(64) COMMENT '测试案例库日志id',
  `temp_json` LONGTEXT COMMENT '中间变量json',
  `scores_json` LONGTEXT COMMENT '评分json',
  `error_msg` VARCHAR(512) COMMENT '错误信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_decision_svc` (
  `id` VARCHAR(64) NOT NULL,
  `svc_def_code` VARCHAR(64) COMMENT '决策服务定义',
  `version` INT COMMENT '版本',
  `status` SMALLINT COMMENT '状态',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `create_user` VARCHAR(64) COMMENT '创建用户',
  `start_user` VARCHAR(64) COMMENT '启用用户',
  `end_user` VARCHAR(64) COMMENT '停用用户',
  `create_time` DATETIME COMMENT '创建时间',
  `start_time` DATETIME COMMENT '启用时间',
  `end_time` DATETIME COMMENT '停用时间',
  `error_msg` LONGTEXT COMMENT '错误提示',
  `shunts` BIGINT COMMENT '分流比例',
  `review_user` VARCHAR(64),
  `review_time` DATETIME,
  `ref_version` INT COMMENT '导出基于版本',
  `name` VARCHAR(64) COMMENT '服务名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_index_library_log` (
  `id` BIGINT NOT NULL,
  `library_id` BIGINT NOT NULL,
  `field_id` BIGINT NOT NULL,
  `library_version` INT,
  `field_version` INT,
  `create_time` DATETIME(6),
  `create_user` DECIMAL(38,0),
  `field_status` VARCHAR(2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_flow` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `dsp_code` VARCHAR(64) COMMENT '调度编号',
  `version` INT COMMENT '版本',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `status` SMALLINT COMMENT '状态',
  `create_user` VARCHAR(64) COMMENT '创建用户',
  `start_user` VARCHAR(64) COMMENT '启用用户',
  `end_user` VARCHAR(64) COMMENT '停用用户',
  `create_time` DATETIME COMMENT '创建时间',
  `start_time` DATETIME COMMENT '启用时间',
  `end_time` DATETIME COMMENT '停用时间',
  `error_msg` LONGTEXT COMMENT '错误提示',
  `shunts` BIGINT COMMENT '分流比例',
  `review_user` VARCHAR(64) COMMENT '复核用户',
  `review_time` DATETIME COMMENT '复核时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_business` (
  `id` BIGINT NOT NULL,
  `name` VARCHAR(1020) NOT NULL,
  `parent_id` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_experiment_result` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `group_id` VARCHAR(64) COMMENT '分组id',
  `data_id` VARCHAR(64) COMMENT '数据id',
  `status` VARCHAR(128) COMMENT '状态',
  `input` LONGTEXT COMMENT '输入',
  `output` LONGTEXT COMMENT '输出',
  `temp` LONGTEXT COMMENT '中间变量',
  `calc` VARCHAR(2) COMMENT '测算结果PN',
  `real_val` VARCHAR(2) COMMENT '真实表现PN',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验结果';

CREATE TABLE `de_di_experiment_dataset` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(256) COMMENT '数据集名称',
  `svc_code` VARCHAR(64) COMMENT '服务编号',
  `create_user` VARCHAR(128) COMMENT '创建人',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `org_no` VARCHAR(64) COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验数据集';

CREATE TABLE `de_di_hit_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(512),
  `type` VARCHAR(32) COMMENT '命中类型',
  `position` VARCHAR(1024) COMMENT '命中位置行数（普通规则:1为正向命中,0为反向命中;决策表:单个数字代表命中行数;多维矩阵:多个数字以空格隔开，代表每个维度位置）',
  `execution_log_id` VARCHAR(64) COMMENT '执行记录编号',
  `element_id` VARCHAR(64),
  `ord` BIGINT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_name_list_cate` (
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(64) COMMENT '分类名称',
  `org_no` VARCHAR(64) COMMENT '机构号',
  `p_id` VARCHAR(64) COMMENT '上级分类id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='名单分类';

CREATE TABLE `de_di_operate_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `operate_type` SMALLINT COMMENT '操作类型',
  `operate_obj` SMALLINT COMMENT '操作对象',
  `request_param` LONGTEXT,
  `operator` VARCHAR(32) COMMENT '操作员',
  `operation_time` DATETIME NOT NULL COMMENT '操作时间',
  `operate_st` SMALLINT COMMENT '操作状态',
  `operate_ip` VARCHAR(32) COMMENT '操作来源ip',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_exe_log` (
  `tran_no` VARCHAR(128) NOT NULL,
  `in_tran_no` VARCHAR(256),
  `app` VARCHAR(80) NOT NULL,
  `version` INT,
  `code` VARCHAR(80) NOT NULL,
  `status` CHAR(4) NOT NULL,
  `params` LONGTEXT,
  `input` LONGTEXT,
  `resp_code` VARCHAR(40),
  `resp_msg` VARCHAR(4000),
  `cb_url` VARCHAR(800),
  `result` LONGTEXT,
  `req_time` DATETIME(6),
  `resp_time` DATETIME(6),
  `create_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_model_svc` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `def_code` VARCHAR(64) COMMENT '决策服务定义',
  `version` INT COMMENT '版本',
  `status` SMALLINT COMMENT '状态',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `create_user` VARCHAR(64) COMMENT '创建用户',
  `start_user` VARCHAR(64) COMMENT '启用用户',
  `end_user` VARCHAR(64) COMMENT '停用用户',
  `create_time` DATETIME COMMENT '创建时间',
  `start_time` DATETIME COMMENT '启用时间',
  `end_time` DATETIME COMMENT '停用时间',
  `error_msg` LONGTEXT COMMENT '错误提示',
  `shunts` BIGINT COMMENT '分流比例',
  `review_user` VARCHAR(64) COMMENT '复核人员',
  `review_time` DATETIME COMMENT '复核时间',
  `pmml` LONGTEXT COMMENT 'pmml',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型服务';

CREATE TABLE `lsp_role_menu` (
  `id` DECIMAL(20,0) NOT NULL,
  `role_id` DECIMAL(20,0) NOT NULL,
  `menu_id` DECIMAL(20,0) NOT NULL,
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色菜单';

CREATE TABLE `de_di_dsp_proc` (
  `id` VARCHAR(64) COMMENT '主键',
  `type` SMALLINT COMMENT '处理器类型',
  `node_id` VARCHAR(64) COMMENT '节点编号',
  `code` VARCHAR(64) COMMENT '处理器编号',
  `sync` SMALLINT COMMENT '是否同步',
  `mapping_script` LONGTEXT COMMENT '映射脚本',
  `ref_lib_code` VARCHAR(64) COMMENT '关联指标库编号',
  `flow_id` VARCHAR(64) COMMENT '流程id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_derive_temp_result` (
  `template_id` BIGINT NOT NULL COMMENT '模版ID',
  `derive_id` BIGINT NOT NULL COMMENT '衍生指标ID',
  `params` VARCHAR(1024) COMMENT '参数列表(逗号隔开)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='衍生指标模板返回结果表';

CREATE TABLE `df_derive_field` (
  `id` BIGINT NOT NULL,
  `aggregate_function` VARCHAR(128),
  `code` VARCHAR(1020) NOT NULL,
  `iterator` BIGINT,
  `name` VARCHAR(1020) NOT NULL,
  `df_script` LONGTEXT,
  `df_json` LONGTEXT,
  `status` VARCHAR(8) NOT NULL,
  `type` VARCHAR(8) NOT NULL,
  `interface_id` BIGINT NOT NULL,
  `distinct_field` VARCHAR(144),
  `data_type` VARCHAR(8) NOT NULL,
  `dept_id` VARCHAR(144),
  `html` LONGTEXT,
  `fields` VARCHAR(2048),
  `version` INT,
  `organ_id` VARCHAR(128),
  `organ_ids` VARCHAR(1020),
  `create_by` VARCHAR(128),
  `create_time` DATETIME,
  `default_value` VARCHAR(400),
  `bits` BIGINT,
  `update_by` VARCHAR(1020),
  `update_time` DATETIME,
  `distinct_field_id` BIGINT COMMENT '去重字段id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_actinst` (
  `id_` VARCHAR(128) NOT NULL,
  `proc_def_id_` VARCHAR(128) NOT NULL,
  `proc_inst_id_` VARCHAR(128) NOT NULL,
  `execution_id_` VARCHAR(128) NOT NULL,
  `act_id_` VARCHAR(510) NOT NULL,
  `task_id_` VARCHAR(128),
  `call_proc_inst_id_` VARCHAR(128),
  `act_name_` VARCHAR(510),
  `act_type_` VARCHAR(510) NOT NULL,
  `assignee_` VARCHAR(510),
  `start_time_` DATETIME(6) NOT NULL,
  `end_time_` DATETIME(6),
  `duration_` DECIMAL(19,0),
  `delete_reason_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_job` (
  `job_id` DECIMAL(38,0) NOT NULL,
  `job_name` VARCHAR(256) NOT NULL,
  `job_group` VARCHAR(256) NOT NULL,
  `invoke_target` VARCHAR(2000) NOT NULL,
  `cron_expression` VARCHAR(1020),
  `misfire_policy` VARCHAR(80),
  `concurrent` CHAR(4),
  `status` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_decision_lib` (
  `id` VARCHAR(64) NOT NULL COMMENT '决策库ID',
  `name` VARCHAR(100) COMMENT '决策库名称',
  `svc_def_code` VARCHAR(64) COMMENT '归属决策服务',
  `create_time` DATETIME COMMENT '创建时间',
  `org_no` VARCHAR(64) COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_flow` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `svc_id` VARCHAR(64) COMMENT '决策服务',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_log` (
  `id` VARCHAR(64) NOT NULL,
  `tran_no` VARCHAR(64),
  `create_time` DATETIME,
  `start_time` DATETIME,
  `end_time` DATETIME,
  `status` SMALLINT,
  `dispatcher_code` VARCHAR(64),
  `version` INT,
  `input` LONGTEXT,
  `output` LONGTEXT,
  `owner` VARCHAR(64),
  `error_code` VARCHAR(64),
  `error_msg` VARCHAR(512),
  `cnt` SMALLINT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `gen_table` (
  `table_id` DECIMAL(38,0) NOT NULL,
  `table_name` VARCHAR(800),
  `table_comment` VARCHAR(2000),
  `class_name` VARCHAR(400),
  `tpl_category` VARCHAR(800),
  `package_name` VARCHAR(400),
  `module_name` VARCHAR(120),
  `business_name` VARCHAR(120),
  `function_name` VARCHAR(200),
  `function_author` VARCHAR(200),
  `gen_type` CHAR(4),
  `gen_path` VARCHAR(800),
  `options` VARCHAR(4000),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ge_property` (
  `name_` VARCHAR(128) NOT NULL,
  `value_` VARCHAR(600),
  `rev_` INT,
  PRIMARY KEY (`name_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_data_source_db_info` (
  `id` BIGINT NOT NULL,
  `source_id` BIGINT,
  `name` VARCHAR(1020) NOT NULL,
  `db_type` VARCHAR(256) NOT NULL,
  `db_host` VARCHAR(1020) NOT NULL,
  `db_port` BIGINT NOT NULL,
  `db_name` VARCHAR(1020) NOT NULL,
  `db_username` VARCHAR(400) NOT NULL,
  `db_password` VARCHAR(400) NOT NULL,
  `max_size` BIGINT,
  `minimum_idle` BIGINT,
  `idle_timeout` BIGINT,
  `conn_timeout` BIGINT,
  `user_auth_db_name` VARCHAR(128),
  `db_schema` VARCHAR(1020)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_dict_data` (
  `dict_code` DECIMAL(38,0) NOT NULL,
  `dict_sort` BIGINT,
  `dict_label` VARCHAR(400),
  `dict_value` VARCHAR(400),
  `dict_type` VARCHAR(400),
  `css_class` VARCHAR(400),
  `list_class` VARCHAR(400),
  `is_default` CHAR(4),
  `status` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000),
  `filter` VARCHAR(1020)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_timer_job` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `type_` VARCHAR(510) NOT NULL,
  `lock_exp_time_` DATETIME(6),
  `lock_owner_` VARCHAR(510),
  `exclusive_` TINYINT,
  `execution_id_` VARCHAR(128),
  `process_instance_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `retries_` INT,
  `exception_stack_id_` VARCHAR(128),
  `exception_msg_` VARCHAR(4000),
  `duedate_` DATETIME(6),
  `repeat_` VARCHAR(510),
  `handler_type_` VARCHAR(510),
  `handler_cfg_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_timer_job` ADD CONSTRAINT `act_fk_tjob_exception` FOREIGN KEY (`exception_stack_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_ru_timer_job` ADD CONSTRAINT `act_fk_tjob_execution` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_timer_job` ADD CONSTRAINT `act_fk_tjob_process_instance` FOREIGN KEY (`process_instance_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_timer_job` ADD CONSTRAINT `act_fk_tjob_proc_def` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_fun_svc_def_ref` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `fun_code` VARCHAR(64) COMMENT '函数主键',
  `svc_def_code` VARCHAR(64) COMMENT '服务模板主键',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_experiment_worth` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(128) COMMENT '名称',
  `experiment_id` VARCHAR(64) COMMENT '实验id',
  `html` LONGTEXT COMMENT '汇总值页面',
  `script` LONGTEXT COMMENT '汇总值脚本',
  `summary_type` INT COMMENT '汇总方式',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验价值';

CREATE TABLE `df_library_field` (
  `id` BIGINT NOT NULL,
  `library_id` BIGINT NOT NULL,
  `interface_id` VARCHAR(200),
  `field_code` VARCHAR(400) NOT NULL,
  `field_name` VARCHAR(400) NOT NULL,
  `parent_id` BIGINT,
  `type` VARCHAR(8),
  `script` LONGTEXT,
  `json` LONGTEXT,
  `create_time` DATETIME(6),
  `create_user` DECIMAL(38,0),
  `field_type` VARCHAR(1020),
  `length` BIGINT,
  `accuracy` BIGINT,
  `version` INT,
  `status` VARCHAR(8),
  `fields` VARCHAR(2048),
  `html` LONGTEXT,
  `display_type` VARCHAR(8),
  `param_type` CHAR(4),
  `directly_related` VARCHAR(8),
  `sort_order` VARCHAR(8),
  `sort_field` VARCHAR(1020),
  `sort` VARCHAR(8),
  `hierarchy` VARCHAR(1020),
  `preheat` VARCHAR(8),
  `invoked_fields` VARCHAR(255) COMMENT '二次衍生引用的衍生指标id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_name_list_data` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(256) COMMENT '客户名称',
  `type` SMALLINT COMMENT '证件类型',
  `code` VARCHAR(128) COMMENT '证件编号',
  `list_id` VARCHAR(64) COMMENT '名单编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='名单数据表';

CREATE TABLE `lsp_oper_log` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '日志主键',
  `title` VARCHAR(100) COMMENT '模块标题',
  `business_type` VARCHAR(40) COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` VARCHAR(200) COMMENT '方法名称',
  `request_method` VARCHAR(20) COMMENT '请求方式',
  `operator_type` VARCHAR(40) COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` VARCHAR(100) COMMENT '操作人员',
  `dept_name` VARCHAR(100) COMMENT '部门名称',
  `oper_url` VARCHAR(510) COMMENT '请求URL',
  `oper_ip` VARCHAR(256) COMMENT '主机地址',
  `oper_param` LONGTEXT COMMENT '请求参数',
  `json_result` LONGTEXT COMMENT '返回参数',
  `status` BIGINT COMMENT '操作状态（0正常 1异常）',
  `error_msg` LONGTEXT COMMENT '错误消息',
  `oper_time` DATETIME COMMENT '操作时间',
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME,
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志记录';

CREATE TABLE `act_re_deployment` (
  `id_` VARCHAR(128) NOT NULL,
  `name_` VARCHAR(510),
  `category_` VARCHAR(510),
  `key_` VARCHAR(510),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  `deploy_time_` DATETIME(6),
  `engine_version_` VARCHAR(510),
  `version_` INT DEFAULT '1',
  `project_release_version_` VARCHAR(510),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_internal_data_column` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `table_name` VARCHAR(128) NOT NULL COMMENT '表的名称',
  `column_name` VARCHAR(128) NOT NULL COMMENT '列的名称',
  `ordinal_position` BIGINT NOT NULL COMMENT '列的序数位置',
  `column_default` VARCHAR(128) COMMENT '列的默认值',
  `not_null` VARCHAR(6) COMMENT 'Y:不能为NULL，N:可以为NULL',
  `data_type` VARCHAR(128) COMMENT '列的数据类型',
  `length` BIGINT COMMENT '长度',
  `numeric_scale` BIGINT COMMENT '数值类型的小数位数',
  `pri_key` VARCHAR(6) COMMENT '是否主键，Y是N否',
  `auto_increment` VARCHAR(20) COMMENT '是否自增',
  `column_comment` VARCHAR(1024) COMMENT '列的注释'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='列数据信息';

CREATE TABLE `df_user` (
  `user_id` DECIMAL(38,0) NOT NULL,
  `dept_id` DECIMAL(38,0),
  `user_name` VARCHAR(120) NOT NULL,
  `nick_name` VARCHAR(120) NOT NULL,
  `user_type` VARCHAR(8),
  `email` VARCHAR(200),
  `phonenumber` VARCHAR(44),
  `sex` CHAR(4),
  `avatar` VARCHAR(400),
  `password` VARCHAR(400),
  `status` CHAR(4),
  `del_flag` CHAR(4),
  `login_ip` VARCHAR(200),
  `login_date` DATETIME(6),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_step_log` (
  `id` VARCHAR(160) NOT NULL,
  `task_id` VARCHAR(64),
  `status` SMALLINT,
  `node_id` VARCHAR(512),
  `node_nm` VARCHAR(512),
  `processor_id` VARCHAR(64),
  `processor_nm` VARCHAR(512),
  `processor_code` VARCHAR(64),
  `start_time` DATETIME COMMENT '开始时间',
  `end_time` DATETIME COMMENT '结束时间',
  `input` LONGTEXT,
  `output` LONGTEXT,
  `error_code` VARCHAR(64),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_data_encrypt` (
  `id` BIGINT NOT NULL,
  `source_id` BIGINT NOT NULL,
  `encryption_algorithm` VARCHAR(1020) NOT NULL,
  `public_key` LONGTEXT,
  `private_key` LONGTEXT,
  `encryption_type` VARCHAR(1020),
  `created_at` DATETIME(6),
  `updated_at` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_interface` (
  `interface_id` BIGINT NOT NULL COMMENT '主键ID',
  `source_id` BIGINT NOT NULL,
  `biz_type` VARCHAR(80),
  `name` VARCHAR(512) NOT NULL,
  `code` VARCHAR(512) NOT NULL,
  `url` LONGTEXT NOT NULL,
  `req_method` VARCHAR(80) NOT NULL,
  `req_format` VARCHAR(80) NOT NULL,
  `res_format` VARCHAR(80),
  `success_field` VARCHAR(800),
  `success_value` VARCHAR(80),
  `table_name` VARCHAR(1020),
  `status` VARCHAR(8),
  `create_time` DATETIME(6),
  `create_by` VARCHAR(128),
  `update_time` DATETIME(6),
  `update_by` VARCHAR(128),
  `organ_id` VARCHAR(128),
  `organ_ids` VARCHAR(1020),
  `cache_enable` VARCHAR(40) DEFAULT 'N',
  `cache_duration` INT DEFAULT '-1',
  `timeout_enable` VARCHAR(40) DEFAULT 'N',
  `timeout_duration` INT DEFAULT '-1',
  `retry_enable` VARCHAR(40) DEFAULT 'N',
  `retry_count` INT DEFAULT '-1',
  `groovy_script` LONGTEXT,
  `output_data_preprocessing` LONGTEXT,
  PRIMARY KEY (`interface_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_param` (
  `id` VARCHAR(128) NOT NULL COMMENT '主键',
  `code` VARCHAR(128) COMMENT '参数编号',
  `org_no` VARCHAR(128) COMMENT '机构号',
  `name` VARCHAR(128) COMMENT '参数名称',
  `value` VARCHAR(128) COMMENT '参数值',
  `type` SMALLINT COMMENT '字段类型',
  `options` LONGTEXT COMMENT '选项'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统参数表';

CREATE TABLE `de_di_decision_svc_def` (
  `code` VARCHAR(64) NOT NULL COMMENT '决策服务编号',
  `name` VARCHAR(100) COMMENT '规则集名称',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `template` LONGTEXT,
  `status` SMALLINT COMMENT '模板状态',
  `type` SMALLINT COMMENT '模板类型',
  `cate_id` VARCHAR(64) COMMENT '模板分类id',
  `index_lib_id` VARCHAR(64),
  `html` LONGTEXT COMMENT '验证规则页面',
  `script` LONGTEXT COMMENT '验证规则脚本',
  `monitor_field` LONGTEXT COMMENT '监控指标',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_post_permission_ref` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `post_code` VARCHAR(64) NOT NULL COMMENT '岗位编号',
  `svc_code` VARCHAR(128) COMMENT '服务编号',
  `component_range` VARCHAR(6) NOT NULL COMMENT '组件范围(决策流/组件包/组件)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='岗位权限表';

CREATE TABLE `df_config` (
  `config_id` BIGINT NOT NULL COMMENT '参数主键',
  `config_name` VARCHAR(400) COMMENT '参数名称',
  `config_key` VARCHAR(400) COMMENT '参数键名',
  `config_value` VARCHAR(2000) COMMENT '参数键值',
  `config_type` CHAR(4) COMMENT '系统内置（Y是 N否）',
  `create_by` VARCHAR(256) COMMENT '创建者',
  `create_time` DATETIME(6) COMMENT '创建时间',
  `update_by` VARCHAR(256) COMMENT '更新者',
  `update_time` DATETIME(6) COMMENT '更新时间',
  `remark` VARCHAR(2000) COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='参数配置表';

CREATE TABLE `df_field_dict` (
  `id` BIGINT NOT NULL,
  `code` VARCHAR(1020) NOT NULL,
  `name` VARCHAR(1020) NOT NULL,
  `field_id` BIGINT NOT NULL,
  `dest_code` VARCHAR(1020),
  `dict_type` CHAR(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_integration` (
  `id_` VARCHAR(128) NOT NULL,
  `execution_id_` VARCHAR(128),
  `process_instance_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `flow_node_id_` VARCHAR(128),
  `created_date_` DATETIME(6),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_integration` ADD CONSTRAINT `act_fk_int_execution` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_integration` ADD CONSTRAINT `act_fk_int_proc_inst` FOREIGN KEY (`process_instance_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_integration` ADD CONSTRAINT `act_fk_int_proc_def` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_task_log` (
  `id` VARCHAR(128) NOT NULL COMMENT '主键',
  `task_id` VARCHAR(128) COMMENT '任务主键',
  `execute_time` DATETIME COMMENT '执行时间',
  `result` VARCHAR(64) COMMENT '执行结果',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_job` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `type_` VARCHAR(510) NOT NULL,
  `lock_exp_time_` DATETIME(6),
  `lock_owner_` VARCHAR(510),
  `exclusive_` TINYINT,
  `execution_id_` VARCHAR(128),
  `process_instance_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `retries_` INT,
  `exception_stack_id_` VARCHAR(128),
  `exception_msg_` VARCHAR(4000),
  `duedate_` DATETIME(6),
  `repeat_` VARCHAR(510),
  `handler_type_` VARCHAR(510),
  `handler_cfg_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_job` ADD CONSTRAINT `act_fk_job_exception` FOREIGN KEY (`exception_stack_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_ru_job` ADD CONSTRAINT `act_fk_job_execution` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_job` ADD CONSTRAINT `act_fk_job_process_instance` FOREIGN KEY (`process_instance_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_job` ADD CONSTRAINT `act_fk_job_proc_def` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_fun` (
  `code` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(100) COMMENT '函数名称',
  `status` SMALLINT COMMENT '状态',
  `wr` SMALLINT COMMENT '无返回值',
  `return_type` SMALLINT COMMENT '返回值类型',
  `return_option` LONGTEXT COMMENT '返回值选项',
  `fun_script` LONGTEXT COMMENT '函数脚本',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_suspended_job` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `type_` VARCHAR(510) NOT NULL,
  `exclusive_` TINYINT,
  `execution_id_` VARCHAR(128),
  `process_instance_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `retries_` INT,
  `exception_stack_id_` VARCHAR(128),
  `exception_msg_` VARCHAR(4000),
  `duedate_` DATETIME(6),
  `repeat_` VARCHAR(510),
  `handler_type_` VARCHAR(510),
  `handler_cfg_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_suspended_job` ADD CONSTRAINT `act_fk_sjob_exception` FOREIGN KEY (`exception_stack_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_ru_suspended_job` ADD CONSTRAINT `act_fk_sjob_execution` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_suspended_job` ADD CONSTRAINT `act_fk_sjob_process_instance` FOREIGN KEY (`process_instance_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_suspended_job` ADD CONSTRAINT `act_fk_sjob_proc_def` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `act_ru_execution` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `proc_inst_id_` VARCHAR(128),
  `business_key_` VARCHAR(510),
  `parent_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `super_exec_` VARCHAR(128),
  `root_proc_inst_id_` VARCHAR(128),
  `act_id_` VARCHAR(510),
  `is_active_` TINYINT,
  `is_concurrent_` TINYINT,
  `is_scope_` TINYINT,
  `is_event_scope_` TINYINT,
  `is_mi_root_` TINYINT,
  `suspension_state_` INT,
  `cached_ent_state_` INT,
  `tenant_id_` VARCHAR(510) DEFAULT '',
  `name_` VARCHAR(510),
  `start_time_` DATETIME(6),
  `start_user_id_` VARCHAR(510),
  `lock_time_` DATETIME(6),
  `is_count_enabled_` TINYINT,
  `evt_subscr_count_` INT,
  `task_count_` INT,
  `job_count_` INT,
  `timer_job_count_` INT,
  `susp_job_count_` INT,
  `deadletter_job_count_` INT,
  `var_count_` INT,
  `id_link_count_` INT,
  `app_version_` INT,
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_execution` ADD CONSTRAINT `act_fk_exe_procinst` FOREIGN KEY (`proc_inst_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_execution` ADD CONSTRAINT `act_fk_exe_parent` FOREIGN KEY (`parent_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_execution` ADD CONSTRAINT `act_fk_exe_super` FOREIGN KEY (`super_exec_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_execution` ADD CONSTRAINT `act_fk_exe_procdef` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_model_execution_log` (
  `desire_rs` CHAR(2) COMMENT '期望结果',
  `id` VARCHAR(64) NOT NULL COMMENT '内部交易流水',
  `in_json` LONGTEXT COMMENT '输入json',
  `org_no` VARCHAR(64) COMMENT '机构',
  `out_json` LONGTEXT COMMENT '输出json',
  `prediction_rs` CHAR(2) COMMENT '预测结果',
  `scores_json` LONGTEXT COMMENT '评分json',
  `server_mark` VARCHAR(32) COMMENT '执行服务器ip',
  `start_date` DATETIME COMMENT '开始时间',
  `status` SMALLINT COMMENT '执行状态',
  `def_code` VARCHAR(64) COMMENT '服务编号',
  `temp_json` LONGTEXT COMMENT '中间变量json',
  `time` DECIMAL(20,0) COMMENT '执行秒数',
  `tran_no` VARCHAR(64) COMMENT '外部交易流水',
  `version` INT COMMENT '版本',
  `error_msg` VARCHAR(512) COMMENT '错误信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型执行日志';

CREATE TABLE `df_library_field_his` (
  `id` BIGINT NOT NULL,
  `old_id` BIGINT,
  `library_id` BIGINT,
  `interface_id` VARCHAR(200),
  `field_code` VARCHAR(400),
  `field_name` VARCHAR(400),
  `parent_id` BIGINT,
  `type` VARCHAR(8),
  `script` LONGTEXT,
  `json` LONGTEXT,
  `create_time` DATETIME(6),
  `create_user` DECIMAL(38,0),
  `field_type` VARCHAR(1020),
  `length` BIGINT,
  `accuracy` BIGINT,
  `version` INT,
  `status` VARCHAR(8),
  `fields` VARCHAR(2048),
  `html` LONGTEXT,
  `display_type` VARCHAR(8),
  `param_type` CHAR(4),
  `directly_related` VARCHAR(8),
  `sort_order` VARCHAR(8),
  `sort_field` VARCHAR(1020),
  `sort` VARCHAR(8),
  `hierarchy` VARCHAR(1020),
  `preheat` VARCHAR(8)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_backtrack_task_log` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键id',
  `status` VARCHAR(4) COMMENT '状态0-进行中，1-已完成',
  `task_name` VARCHAR(100) NOT NULL COMMENT '回溯任务名称',
  `task_id` DECIMAL(20,0) NOT NULL COMMENT '回溯任务id',
  `create_time` DATETIME COMMENT '创建时间',
  `create_user` VARCHAR(60) COMMENT '创建用户',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回溯任务日志表';

CREATE TABLE `df_backtrack_task` (
  `task_id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `task_name` VARCHAR(100) COMMENT '回溯任务名称',
  `task_type` VARCHAR(4) COMMENT '回溯任务类型: 0-单库测试，1-对比测试',
  `library_id` DECIMAL(20,0) COMMENT '指标库id',
  `library_version` INT COMMENT '版本',
  `compare_library_version` INT COMMENT '对比的版本：对比测试的任务才有值',
  `dataset_id` DECIMAL(20,0) COMMENT '回溯数据集的id',
  `create_time` DATETIME COMMENT '创建时间',
  `create_by` VARCHAR(64) COMMENT '创建用户',
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回溯任务';

CREATE TABLE `df_batch_execute_mapping` (
  `id` DECIMAL(20,0) NOT NULL,
  `task_id` DECIMAL(20,0) COMMENT '任务名称',
  `source_table` VARCHAR(128) COMMENT '源表',
  `source_code` VARCHAR(128) COMMENT '源字段code',
  `target_code` VARCHAR(128) COMMENT '目标字段code',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='批量回溯映射关系';

CREATE TABLE `df_process` (
  `process_id` VARCHAR(128) NOT NULL,
  `category` VARCHAR(1020),
  `sponsor` DECIMAL(38,0),
  `start_date` DATETIME(6),
  `state` CHAR(4),
  `deal_date` DATETIME(6),
  `deal_state` CHAR(4),
  `business_key` VARCHAR(256),
  `process_name` VARCHAR(512)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_identitylink` (
  `id_` VARCHAR(128) NOT NULL,
  `group_id_` VARCHAR(510),
  `type_` VARCHAR(510),
  `user_id_` VARCHAR(510),
  `task_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_identitylink` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `group_id_` VARCHAR(510),
  `type_` VARCHAR(510),
  `user_id_` VARCHAR(510),
  `task_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_identitylink` ADD CONSTRAINT `act_fk_idl_procinst` FOREIGN KEY (`proc_inst_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_identitylink` ADD CONSTRAINT `act_fk_tskass_task` FOREIGN KEY (`task_id_`) REFERENCES `act_ru_task`(`id_`);

ALTER TABLE `act_ru_identitylink` ADD CONSTRAINT `act_fk_athrz_procedef` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `df_link_dest` (
  `id` BIGINT NOT NULL,
  `link_id` BIGINT NOT NULL,
  `dest_code` VARCHAR(400),
  `dest_name` VARCHAR(512),
  `dest_id` BIGINT,
  `library_id` BIGINT,
  `dest_column_id` BIGINT,
  `type` VARCHAR(8) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_file_source` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键id',
  `file_id` VARCHAR(128) NOT NULL COMMENT '文件识别id',
  `file_name` VARCHAR(1024) NOT NULL COMMENT '重命名的文件名称(唯一)',
  `file_source_name` VARCHAR(1024) COMMENT '文件名',
  `file_type` VARCHAR(40) COMMENT '文件类别',
  `del_flag` CHAR(2) COMMENT '删除标志：0-正常，1-已删除',
  `file_path` VARCHAR(1024) NOT NULL COMMENT '文件路径',
  `file_release_user` VARCHAR(64) COMMENT '上传者',
  `file_date` DATETIME COMMENT '上传日期',
  `file_size` VARCHAR(200) COMMENT '文件大小',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文件表';

CREATE TABLE `de_di_decision_element` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `pkg_id` VARCHAR(64) COMMENT '归属包',
  `cate_id` VARCHAR(64) COMMENT '归属分类',
  `ord` INT,
  `name` VARCHAR(100) COMMENT '规则名称',
  `html` LONGTEXT,
  `script` LONGTEXT,
  `status` SMALLINT,
  `template_id` VARCHAR(64),
  `rule_biz_code` VARCHAR(64) COMMENT '业务编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_score_card_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `total` INT COMMENT '总分',
  `score_card_id` VARCHAR(64) COMMENT '评分卡id',
  `exe_log_id` VARCHAR(64) COMMENT '执行日志id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评分卡执行记录';

CREATE TABLE `df_library_monitoring` (
  `id` BIGINT NOT NULL COMMENT '自增ID',
  `library_id` BIGINT NOT NULL COMMENT '指标库id',
  `app_code` VARCHAR(510) NOT NULL COMMENT '系统名称',
  `status` VARCHAR(20) NOT NULL COMMENT '状态:1-有效,0-无效',
  `call_amount` BIGINT COMMENT '调用量',
  `response_time` BIGINT COMMENT '响应时间（毫秒）',
  `failure_rate` INT COMMENT '失败率 (%)',
  `job_id` DECIMAL(20,0) COMMENT '定时任务ID',
  `last_execution_time` DATETIME COMMENT '上次任务执行时间',
  `gap` BIGINT COMMENT '预警周期(分钟)',
  `remark` LONGTEXT COMMENT '备注',
  `create_user` DECIMAL(20,0) COMMENT '创建用户',
  `create_time` DATETIME COMMENT '创建时间',
  `update_user` DECIMAL(20,0) COMMENT '更新用户',
  `update_time` DATETIME COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标库监控配置表';

CREATE TABLE `de_di_dsp_dict` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '名称',
  `dest_code` VARCHAR(64) COMMENT '映射编号',
  `f_id` VARCHAR(64) COMMENT '所属字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_log_level_config` (
  `id` VARCHAR(128) NOT NULL COMMENT '主键',
  `mark` VARCHAR(128) COMMENT '系统标识',
  `log_name` VARCHAR(128) COMMENT '日志名称',
  `log_class` VARCHAR(256),
  `log_level` SMALLINT COMMENT '日志级别',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日志级别配置';

CREATE TABLE `sys_menu_back` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '编号',
  `parent_id` DECIMAL(20,0) COMMENT '所属上级',
  `name` VARCHAR(40) NOT NULL COMMENT '名称',
  `type` SMALLINT NOT NULL COMMENT '类型(0:目录,1:菜单,2:按钮)',
  `path` VARCHAR(200) COMMENT '路由地址',
  `component` VARCHAR(200) COMMENT '组件路径',
  `perms` VARCHAR(200) COMMENT '权限标识',
  `icon` VARCHAR(200) COMMENT '图标',
  `sort_value` BIGINT COMMENT '排序',
  `status` SMALLINT COMMENT '状态(0:禁止,1:正常)',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）',
  `mark` VARCHAR(64) COMMENT '系统标识',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单表';

CREATE TABLE `lsp_user` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '用户id',
  `username` VARCHAR(40) NOT NULL COMMENT '用户名',
  `password` VARCHAR(64) NOT NULL COMMENT '密码',
  `name` VARCHAR(100) COMMENT '姓名',
  `phone` VARCHAR(22) COMMENT '手机',
  `head_url` VARCHAR(400) COMMENT '头像地址',
  `organ_id` VARCHAR(108) COMMENT '机构id',
  `description` VARCHAR(510) COMMENT '描述',
  `status` SMALLINT COMMENT '状态（1：正常 0：停用）',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

CREATE TABLE `df_post` (
  `post_id` DECIMAL(38,0) NOT NULL,
  `post_code` VARCHAR(256) NOT NULL,
  `post_name` VARCHAR(200) NOT NULL,
  `post_sort` BIGINT NOT NULL,
  `status` CHAR(4) NOT NULL,
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_oper_log` (
  `oper_id` DECIMAL(38,0) NOT NULL,
  `title` VARCHAR(200),
  `business_type` BIGINT,
  `method` VARCHAR(400),
  `request_method` VARCHAR(40),
  `operator_type` BIGINT,
  `oper_name` VARCHAR(200),
  `dept_name` VARCHAR(200),
  `oper_url` VARCHAR(1020),
  `oper_ip` VARCHAR(200),
  `oper_location` VARCHAR(1020),
  `oper_param` LONGTEXT,
  `json_result` LONGTEXT,
  `status` BIGINT,
  `error_msg` LONGTEXT,
  `oper_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_attachment` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `user_id_` VARCHAR(510),
  `name_` VARCHAR(510),
  `description_` VARCHAR(4000),
  `type_` VARCHAR(510),
  `task_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `url_` VARCHAR(4000),
  `content_id_` VARCHAR(128),
  `time_` DATETIME(6),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_custom_parameter` (
  `id` BIGINT NOT NULL,
  `source_id` BIGINT NOT NULL,
  `type` VARCHAR(1020) NOT NULL,
  `identifier` VARCHAR(1020) NOT NULL,
  `value` VARCHAR(1020) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_field_250317` (
  `id` BIGINT NOT NULL,
  `interface_id` BIGINT NOT NULL,
  `code` VARCHAR(200) NOT NULL,
  `name` VARCHAR(400) NOT NULL,
  `field_type` VARCHAR(40) NOT NULL,
  `param_type` VARCHAR(8) NOT NULL,
  `default_value` VARCHAR(200),
  `parent_id` BIGINT,
  `required_flag` VARCHAR(8),
  `is_encrypted` VARCHAR(8),
  `length` BIGINT,
  `accuracy` BIGINT,
  `remark` VARCHAR(1020),
  `order_num` BIGINT,
  `default_value_type` VARCHAR(8)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_log` (
  `id` VARCHAR(64) NOT NULL,
  `tran_no` VARCHAR(64),
  `create_time` DATETIME,
  `start_time` DATETIME,
  `end_time` DATETIME,
  `status` SMALLINT,
  `dispatcher_code` VARCHAR(64),
  `version` INT,
  `input` LONGTEXT,
  `output` LONGTEXT,
  `owner` VARCHAR(64),
  `error_code` VARCHAR(64),
  `error_msg` VARCHAR(512),
  `cnt` SMALLINT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_index_library` (
  `library_id` BIGINT NOT NULL,
  `code` VARCHAR(1020) NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `version` INT,
  `business_id` BIGINT NOT NULL,
  `parent_id` BIGINT NOT NULL,
  `create_time` DATETIME(6),
  `create_user` VARCHAR(128),
  `status` VARCHAR(8) NOT NULL,
  `organ_ids` VARCHAR(2000),
  `organ_id` VARCHAR(128)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_backtrack_dataset` (
  `dataset_id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `dataset_name` VARCHAR(64) COMMENT '数据集名称',
  `library_id` BIGINT COMMENT '指标库id',
  `library_version` INT COMMENT '指标库版本',
  `create_time` DATETIME COMMENT '创建时间',
  `create_by` VARCHAR(64) COMMENT '创建用户',
  PRIMARY KEY (`dataset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回溯数据集';

CREATE TABLE `de_di_model_svc_def` (
  `code` VARCHAR(64) NOT NULL COMMENT '模型服务编号',
  `name` VARCHAR(100) COMMENT '模型名称',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `status` SMALLINT COMMENT '状态',
  `cate_id` VARCHAR(64) COMMENT '归属分类',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型服务定义';

CREATE TABLE `de_di_rule_pkg` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `biz_code` VARCHAR(64) COMMENT '业务编号',
  `svc_id` VARCHAR(64) COMMENT '决策服务',
  `name` VARCHAR(100) COMMENT '规则包名称',
  `hit_return` SMALLINT COMMENT '是否命中退出',
  `ord` INT,
  `p_id` VARCHAR(64) COMMENT '上级包',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_groovy_template` (
  `template_id` BIGINT NOT NULL COMMENT '模版ID(主键)',
  `code` VARCHAR(510) NOT NULL COMMENT '模板code',
  `name` VARCHAR(510) NOT NULL COMMENT '模板名称',
  `groovy_template` LONGTEXT NOT NULL COMMENT '模版groovy',
  `remark` VARCHAR(1024) COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Groovy模版表';

CREATE TABLE `de_di_dec_elm_tmpl` (
  `code` VARCHAR(64) NOT NULL COMMENT '模板编号',
  `name` VARCHAR(100) COMMENT '模板名称',
  `html` LONGTEXT,
  `script` LONGTEXT,
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_role_menu` (
  `role_id` DECIMAL(38,0) NOT NULL,
  `menu_id` DECIMAL(38,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_rule_pkg_execution` (
  `id` VARCHAR(64) NOT NULL,
  `code` VARCHAR(64) COMMENT '规则包业务编号',
  `svc_id` VARCHAR(64) COMMENT '决策服务编号',
  `is_delete` SMALLINT COMMENT '是否删除',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `create_time` DATETIME COMMENT '创建时间',
  `end_time` DATETIME COMMENT '删除时间',
  `script` LONGTEXT,
  `pkg_id` VARCHAR(64) COMMENT '规则包id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_internal_data_index` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '索引ID',
  `table_name` VARCHAR(128) NOT NULL COMMENT '表名',
  `index_name` VARCHAR(128) NOT NULL COMMENT '索引名',
  `columns` VARCHAR(128) NOT NULL COMMENT '列名',
  `type` VARCHAR(510) NOT NULL COMMENT '索引类型',
  `method` VARCHAR(510) NOT NULL COMMENT '索引方法',
  `comment` VARCHAR(512) COMMENT '索引注释'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='存储索引信息的表';

CREATE TABLE `df_field_grant` (
  `field_id` BIGINT NOT NULL,
  `dept_id` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_groovy_template_param` (
  `param_id` BIGINT NOT NULL COMMENT '参数ID(主键)',
  `template_id` BIGINT NOT NULL COMMENT '模版id',
  `code` VARCHAR(510) NOT NULL COMMENT '参数code',
  `name` VARCHAR(510) NOT NULL COMMENT '参数名称',
  `default_value` VARCHAR(510) COMMENT '默认值',
  `required` VARCHAR(4) NOT NULL COMMENT '必填(Y/N)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Groovy模版参数表';

CREATE TABLE `act_hi_procinst` (
  `id_` VARCHAR(128) NOT NULL,
  `proc_inst_id_` VARCHAR(128) NOT NULL,
  `business_key_` VARCHAR(510),
  `proc_def_id_` VARCHAR(128) NOT NULL,
  `start_time_` DATETIME(6) NOT NULL,
  `end_time_` DATETIME(6),
  `duration_` DECIMAL(19,0),
  `start_user_id_` VARCHAR(510),
  `start_act_id_` VARCHAR(510),
  `end_act_id_` VARCHAR(510),
  `super_process_instance_id_` VARCHAR(128),
  `delete_reason_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  `name_` VARCHAR(510),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_experiment` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(256) COMMENT '实验名称',
  `svc_code` VARCHAR(64) COMMENT '服务编号',
  `status` SMALLINT COMMENT '状态',
  `create_user` VARCHAR(128) COMMENT '创建人',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `org_no` VARCHAR(64) COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='策略实验';

CREATE TABLE `de_di_dict` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '名称',
  `dest_code` VARCHAR(64) COMMENT '映射编号',
  `f_id` VARCHAR(64) COMMENT '所属字段',
  `cascade_code` VARCHAR(64) COMMENT '级联code',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_deadletter_job` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `type_` VARCHAR(510) NOT NULL,
  `exclusive_` TINYINT,
  `execution_id_` VARCHAR(128),
  `process_instance_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `exception_stack_id_` VARCHAR(128),
  `exception_msg_` VARCHAR(4000),
  `duedate_` DATETIME(6),
  `repeat_` VARCHAR(510),
  `handler_type_` VARCHAR(510),
  `handler_cfg_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_deadletter_job` ADD CONSTRAINT `act_fk_djob_exception` FOREIGN KEY (`exception_stack_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_ru_deadletter_job` ADD CONSTRAINT `act_fk_djob_execution` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_deadletter_job` ADD CONSTRAINT `act_fk_djob_process_instance` FOREIGN KEY (`process_instance_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_deadletter_job` ADD CONSTRAINT `act_fk_djob_proc_def` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `sys_menu_ref` (
  `id` DECIMAL(20,0) NOT NULL,
  `url_perm` VARCHAR(128),
  `url` VARCHAR(384),
  `status` SMALLINT,
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME NOT NULL,
  `is_deleted` SMALLINT,
  `mark` VARCHAR(192)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_backtrack_data` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `dataset_id` DECIMAL(20,0) COMMENT '回溯数据集id',
  `tran_no` VARCHAR(128) COMMENT '数据服务日志对应的tran_no',
  `create_time` DATETIME COMMENT '创建时间',
  `create_by` VARCHAR(64) COMMENT '创建用户',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回溯数据集的具体测试数据表';

CREATE TABLE `df_variable_monitoring_log` (
  `log_id` BIGINT NOT NULL COMMENT '日志记录唯一标识，自增主键',
  `monitor_id` BIGINT NOT NULL COMMENT '预警ID',
  `type` VARCHAR(20) NOT NULL COMMENT '0-指标预警日志,1-指标库预警日志',
  `variable_name` VARCHAR(200) NOT NULL COMMENT '被监控的变量名称',
  `gap` BIGINT NOT NULL COMMENT '监控频率（分钟）',
  `sample_size` BIGINT NOT NULL COMMENT '样本数量',
  `missing_rate` INT COMMENT '缺失率（0~1之间的小数）',
  `special_value_rate` INT COMMENT '特殊值占比（0~1之间的小数）',
  `psi_value` INT COMMENT 'PSI 指标值（Population Stability Index）',
  `iv_value` INT COMMENT 'IV 指标值（Information Value）',
  `call_amount` BIGINT COMMENT '调用量',
  `failure_rate` INT COMMENT '失败率',
  `response_time` BIGINT COMMENT '响应时间(毫秒)',
  `created_at` DATETIME COMMENT '日志记录的创建时间',
  `app_code` VARCHAR(510) COMMENT '调用系统名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='变量监控日志表，记录监控指标及预警信息';

CREATE TABLE `de_di_dsp` (
  `code` VARCHAR(64) NOT NULL COMMENT '调度服务编号',
  `name` VARCHAR(100) COMMENT '调度服务名称',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `status` SMALLINT COMMENT '状态',
  `cate_id` VARCHAR(64) COMMENT '归属分类',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_taskinst` (
  `id_` VARCHAR(128) NOT NULL,
  `proc_def_id_` VARCHAR(128),
  `task_def_key_` VARCHAR(510),
  `proc_inst_id_` VARCHAR(128),
  `execution_id_` VARCHAR(128),
  `parent_task_id_` VARCHAR(128),
  `name_` VARCHAR(510),
  `description_` VARCHAR(4000),
  `owner_` VARCHAR(510),
  `assignee_` VARCHAR(510),
  `start_time_` DATETIME(6) NOT NULL,
  `claim_time_` DATETIME(6),
  `end_time_` DATETIME(6),
  `duration_` DECIMAL(19,0),
  `delete_reason_` VARCHAR(4000),
  `priority_` INT,
  `due_date_` DATETIME(6),
  `form_key_` VARCHAR(510),
  `category_` VARCHAR(510),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_role` (
  `role_id` DECIMAL(38,0) NOT NULL,
  `role_name` VARCHAR(120) NOT NULL,
  `role_key` VARCHAR(400) NOT NULL,
  `role_sort` BIGINT NOT NULL,
  `data_scope` CHAR(4),
  `menu_check_strictly` BIGINT,
  `dept_check_strictly` BIGINT,
  `status` CHAR(4) NOT NULL,
  `del_flag` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `gen_table_column` (
  `column_id` DECIMAL(38,0) NOT NULL,
  `table_id` VARCHAR(256),
  `column_name` VARCHAR(800),
  `column_comment` VARCHAR(2000),
  `column_type` VARCHAR(400),
  `java_type` VARCHAR(2000),
  `java_field` VARCHAR(800),
  `is_pk` CHAR(4),
  `is_increment` CHAR(4),
  `is_required` CHAR(4),
  `is_insert` CHAR(4),
  `is_edit` CHAR(4),
  `is_list` CHAR(4),
  `is_query` CHAR(4),
  `query_type` VARCHAR(800),
  `html_type` VARCHAR(800),
  `dict_type` VARCHAR(800),
  `sort` BIGINT,
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lsp_login_log` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '访问ID',
  `username` VARCHAR(100) COMMENT '用户账号',
  `ipaddr` VARCHAR(256) COMMENT '登录IP地址',
  `status` SMALLINT COMMENT '登录状态（0成功 1失败）',
  `msg` VARCHAR(510) COMMENT '提示信息',
  `access_time` DATETIME COMMENT '访问时间',
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME,
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统访问记录';

CREATE TABLE `df_dict_type` (
  `dict_id` DECIMAL(38,0) NOT NULL COMMENT '字典主键',
  `dict_name` VARCHAR(400) COMMENT '字典名称',
  `dict_type` VARCHAR(400) COMMENT '字典类型',
  `status` CHAR(4) COMMENT '状态（0正常 1停用）',
  `create_by` VARCHAR(256) COMMENT '创建者',
  `create_time` DATETIME(6) COMMENT '创建时间',
  `update_by` VARCHAR(256) COMMENT '更新者',
  `update_time` DATETIME(6) COMMENT '更新时间',
  `remark` VARCHAR(2000) COMMENT '备注',
  PRIMARY KEY (`dict_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典类型表';

CREATE TABLE `de_di_decision_svc_execution` (
  `id` VARCHAR(64) NOT NULL,
  `svc_def_code` VARCHAR(64) COMMENT '决策服务定义',
  `version` INT,
  `is_delete` SMALLINT COMMENT '是否删除',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `create_time` DATETIME COMMENT '创建时间',
  `end_time` DATETIME COMMENT '删除时间',
  `shunts` BIGINT COMMENT '分流比例',
  `script` LONGTEXT COMMENT '服务脚本',
  `svc_id` VARCHAR(64),
  `index_lib_id` VARCHAR(64),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_backtrack_log` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键id',
  `tran_no` VARCHAR(64) NOT NULL COMMENT '流水号',
  `task_id` DECIMAL(20,0) NOT NULL COMMENT '回溯任务id',
  `status` CHAR(2) NOT NULL COMMENT '状态：0-处理中，1-成功，2-失败',
  `params` LONGTEXT COMMENT '查询的指标集合',
  `resp_code` VARCHAR(20) COMMENT '返回的code',
  `library_version` INT COMMENT '对应指标库版本',
  `result` LONGTEXT COMMENT '结果',
  `req_time` DATETIME COMMENT '请求时间',
  `resp_time` DATETIME COMMENT '响应时间',
  `create_time` DATETIME COMMENT '创建时间',
  `task_log_id` DECIMAL(20,0) COMMENT '任务记录id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回溯日志表';

CREATE TABLE `df_library_auth_info` (
  `id` DECIMAL(38,0) NOT NULL,
  `library_id` DECIMAL(38,0) NOT NULL,
  `organ_id` DECIMAL(38,0) NOT NULL,
  `mount` VARCHAR(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_menu_ref_back` (
  `url_id` DECIMAL(20,0) NOT NULL,
  `parent_id` DECIMAL(20,0),
  `url` VARCHAR(384),
  `status` SMALLINT,
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME NOT NULL,
  `is_deleted` SMALLINT,
  `mark` VARCHAR(192)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_preheat_exe_log` (
  `tran_no` VARCHAR(64) NOT NULL COMMENT '流水号',
  `params` LONGTEXT COMMENT '预热指标',
  `status` CHAR(2) NOT NULL COMMENT '状态：0-处理中，1-成功，2-失败',
  `resp_code` VARCHAR(20) COMMENT '返回的code',
  `resp_msg` VARCHAR(2000) COMMENT '返回的信息',
  `result` LONGTEXT COMMENT '结果',
  `create_time` DATETIME COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预热指标执行日志表';

CREATE TABLE `de_di_post_user_ref` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `post_code` VARCHAR(64) NOT NULL COMMENT '岗位编号',
  `user_code` VARCHAR(128) COMMENT '用户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='岗位用户表';

CREATE TABLE `df_free_marker_template` (
  `id` BIGINT NOT NULL,
  `code` VARCHAR(1020) NOT NULL,
  `name` VARCHAR(1020) NOT NULL,
  `html` LONGTEXT,
  `script` LONGTEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_user_role` (
  `user_id` DECIMAL(38,0) NOT NULL,
  `role_id` DECIMAL(38,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_data_source_web_info` (
  `id` BIGINT NOT NULL,
  `source_id` BIGINT NOT NULL,
  `login_required` VARCHAR(40),
  `user_auth_code` VARCHAR(128),
  `user_auth_value` VARCHAR(1020),
  `user_auth_field` BIGINT,
  `expire_time` BIGINT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_field_monitoring_range` (
  `id` BIGINT NOT NULL COMMENT '主键-自增',
  `limit_id` BIGINT COMMENT '限制表id',
  `min` INT COMMENT '最小值',
  `max` INT COMMENT '最大值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标限制区间表';

CREATE TABLE `df_notice` (
  `notice_id` BIGINT NOT NULL,
  `notice_title` VARCHAR(200) NOT NULL,
  `notice_type` CHAR(4) NOT NULL,
  `notice_content` LONGTEXT,
  `status` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(1020)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_field` (
  `id` BIGINT NOT NULL,
  `interface_id` BIGINT NOT NULL,
  `code` VARCHAR(200) NOT NULL,
  `name` VARCHAR(400) NOT NULL,
  `field_type` VARCHAR(40) NOT NULL,
  `param_type` VARCHAR(8) NOT NULL,
  `default_value` VARCHAR(200),
  `parent_id` BIGINT,
  `required_flag` VARCHAR(8),
  `is_encrypted` VARCHAR(8),
  `length` BIGINT,
  `accuracy` BIGINT,
  `remark` VARCHAR(1020),
  `order_num` BIGINT,
  `default_value_type` VARCHAR(8)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_event_subscr` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `event_type_` VARCHAR(510) NOT NULL,
  `event_name_` VARCHAR(510),
  `execution_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `activity_id_` VARCHAR(128),
  `configuration_` VARCHAR(510),
  `created_` DATETIME(6) NOT NULL,
  `proc_def_id_` VARCHAR(128),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_event_subscr` ADD CONSTRAINT `act_fk_event_exec` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

CREATE TABLE `de_di_experiment_hit_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `element_id` VARCHAR(64) COMMENT '命中组件id',
  `result_id` VARCHAR(64) COMMENT '执行记录编号',
  `name` VARCHAR(512) COMMENT '命中组件名称',
  `ord` BIGINT COMMENT '序号',
  `position` VARCHAR(32) COMMENT '命中位置行数（普通规则:1为正向命中,0为反向命中;决策表:单个数字代表命中行数;多维矩阵:多个数字以空格隔开，代表每个维度位置）',
  `type` VARCHAR(32) COMMENT '命中类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验结果命中明细';

CREATE TABLE `df_call_interface_log` (
  `id` DECIMAL(38,0) NOT NULL,
  `tran_no` VARCHAR(128),
  `interface_id` BIGINT,
  `url` LONGTEXT,
  `req` LONGTEXT,
  `res` LONGTEXT,
  `status` VARCHAR(8),
  `call_time` DATETIME(6),
  `resp_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_menu` (
  `menu_id` DECIMAL(38,0) NOT NULL COMMENT '菜单ID',
  `menu_name` VARCHAR(200) NOT NULL COMMENT '菜单名称',
  `parent_id` DECIMAL(38,0) COMMENT '父菜单ID',
  `order_num` BIGINT COMMENT '显示顺序',
  `path` VARCHAR(800) COMMENT '路由地址',
  `component` VARCHAR(1020) COMMENT '组件路径',
  `is_frame` BIGINT COMMENT '是否为外链（0是 1否）',
  `is_cache` BIGINT COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` CHAR(4) COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` CHAR(4) COMMENT '菜单状态（0显示 1隐藏）',
  `status` CHAR(4) COMMENT '菜单状态（0正常 1停用）',
  `perms` VARCHAR(400) COMMENT '权限标识',
  `icon` VARCHAR(400) COMMENT '菜单图标',
  `create_by` VARCHAR(256) COMMENT '创建者',
  `create_time` DATETIME(6) COMMENT '创建时间',
  `update_by` VARCHAR(256) COMMENT '更新者',
  `update_time` DATETIME(6) COMMENT '更新时间',
  `remark` VARCHAR(2000) COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

CREATE TABLE `de_di_dsp_link` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `src` VARCHAR(64) COMMENT '源节点',
  `dest` VARCHAR(64) COMMENT '目标节点',
  `c_script` LONGTEXT COMMENT '条件脚本',
  `c_view` LONGTEXT COMMENT '条件视图',
  `desc_info` VARCHAR(100) COMMENT '描述',
  `p_x` VARCHAR(32) COMMENT '位置x',
  `p_y` VARCHAR(32) COMMENT '位置y',
  `width` VARCHAR(32) COMMENT '宽',
  `height` VARCHAR(32) COMMENT '高',
  `s_p` VARCHAR(32) COMMENT '源连接点位置',
  `t_p` VARCHAR(32) COMMENT '目标连接点位置',
  `flow_id` VARCHAR(64) COMMENT '流程编号',
  `points` VARCHAR(256) COMMENT '连线轨迹',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_node` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(100) COMMENT '节点名称',
  `type` SMALLINT COMMENT '节点类型',
  `p_x` VARCHAR(32) COMMENT '位置x',
  `p_y` VARCHAR(32) COMMENT '位置y',
  `width` VARCHAR(32) COMMENT '宽',
  `height` VARCHAR(32) COMMENT '高',
  `flow_id` VARCHAR(64) COMMENT '流程编号',
  `ord` INT COMMENT '序号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_re_model` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `name_` VARCHAR(510),
  `key_` VARCHAR(510),
  `category_` VARCHAR(510),
  `create_time_` DATETIME(6),
  `last_update_time_` DATETIME(6),
  `version_` INT,
  `meta_info_` VARCHAR(4000),
  `deployment_id_` VARCHAR(128),
  `editor_source_value_id_` VARCHAR(128),
  `editor_source_extra_value_id_` VARCHAR(128),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_re_model` ADD CONSTRAINT `act_fk_model_source` FOREIGN KEY (`editor_source_value_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_re_model` ADD CONSTRAINT `act_fk_model_source_extra` FOREIGN KEY (`editor_source_extra_value_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_re_model` ADD CONSTRAINT `act_fk_model_deployment` FOREIGN KEY (`deployment_id_`) REFERENCES `act_re_deployment`(`id_`);

CREATE TABLE `de_di_decision_cate` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(100) COMMENT '名称',
  `p_id` VARCHAR(64) COMMENT '上级分类',
  `lib_id` VARCHAR(64) COMMENT '归属决策库',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_logininfor` (
  `info_id` DECIMAL(38,0) NOT NULL,
  `user_name` VARCHAR(200),
  `ipaddr` VARCHAR(200),
  `login_location` VARCHAR(1020),
  `browser` VARCHAR(200),
  `os` VARCHAR(200),
  `status` CHAR(4),
  `msg` VARCHAR(1020),
  `login_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_field` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '字段名称',
  `type` SMALLINT COMMENT '数据类型',
  `default_value` VARCHAR(1000) COMMENT '固定默认值',
  `empty_default_value` VARCHAR(1000) COMMENT '为空默认值',
  `status` SMALLINT COMMENT '状态',
  `p_id` VARCHAR(64) COMMENT '上级字段',
  `dsp_code` VARCHAR(64) COMMENT '调度编号',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_field_map` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `src_code` VARCHAR(512) COMMENT '源code',
  `dest_code` VARCHAR(128) COMMENT '目标code',
  `processor_id` VARCHAR(64) COMMENT '处理器编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_re_procdef` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `category_` VARCHAR(510),
  `name_` VARCHAR(510),
  `key_` VARCHAR(510) NOT NULL,
  `version_` INT NOT NULL,
  `deployment_id_` VARCHAR(128),
  `resource_name_` VARCHAR(4000),
  `dgrm_resource_name_` VARCHAR(4000),
  `description_` VARCHAR(4000),
  `has_start_form_key_` TINYINT,
  `has_graphical_notation_` TINYINT,
  `suspension_state_` INT,
  `tenant_id_` VARCHAR(510) DEFAULT '',
  `engine_version_` VARCHAR(510),
  `app_version_` INT,
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_internal_data_table` (
  `table_name` VARCHAR(128) NOT NULL COMMENT '表的名称',
  `engine` VARCHAR(510) COMMENT '表使用的存储引擎',
  `create_time` DATETIME COMMENT '表的创建时间',
  `update_time` DATETIME COMMENT '表的最后更新时间',
  `table_comment` LONGTEXT COMMENT '表的注释'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='表数据信息';

CREATE TABLE `sys_dict_type` (
  `dict_id` DECIMAL(38,0) NOT NULL,
  `dict_name` VARCHAR(400),
  `dict_type` VARCHAR(400),
  `status` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_black_white_list` (
  `id` BIGINT NOT NULL,
  `user_type` VARCHAR(8) NOT NULL,
  `list_type` VARCHAR(8) NOT NULL,
  `id_no` VARCHAR(80),
  `id_no_prefix` VARCHAR(40),
  `id_type` VARCHAR(80),
  `name` VARCHAR(200),
  `name_keyword` VARCHAR(200),
  `mobile` VARCHAR(80),
  `mobile_prefix` VARCHAR(40),
  `status` VARCHAR(8) NOT NULL,
  `effective_time` DATETIME(6),
  `expire_time` DATETIME(6),
  `scene_scope` VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_batch_execute` (
  `task_id` DECIMAL(20,0) NOT NULL,
  `task_name` VARCHAR(200) COMMENT '任务名称',
  `library_id` DECIMAL(20,0) COMMENT '指标库ID',
  `library_version` DECIMAL(3,1) COMMENT '指标库版本',
  `starting_method` VARCHAR(4) COMMENT '1-人工触发 2-定时任务',
  `job_id` DECIMAL(20,0) COMMENT '定时任务id',
  `cron` VARCHAR(60) COMMENT 'cron表达式',
  `input_param_source` VARCHAR(4) COMMENT '1-文件导入 2-内部数据库',
  `file_id` VARCHAR(128) COMMENT '文件ID',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='批量回溯';

CREATE TABLE `df_dept` (
  `dept_id` DECIMAL(38,0) NOT NULL,
  `parent_id` DECIMAL(38,0),
  `ancestors` VARCHAR(200),
  `dept_name` VARCHAR(120),
  `order_num` BIGINT,
  `leader` VARCHAR(80),
  `phone` VARCHAR(44),
  `email` VARCHAR(200),
  `status` CHAR(4),
  `del_flag` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_limitation_waring_log` (
  `id` BIGINT NOT NULL,
  `tran_no` VARCHAR(1020) NOT NULL,
  `field_id` BIGINT NOT NULL,
  `res` VARCHAR(1020),
  `create_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_user_post` (
  `user_id` DECIMAL(38,0) NOT NULL,
  `post_id` DECIMAL(38,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lsp_user_role` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键id',
  `role_id` DECIMAL(20,0) NOT NULL COMMENT '角色id',
  `user_id` DECIMAL(20,0) NOT NULL COMMENT '用户id',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色';

CREATE TABLE `act_hi_varinst` (
  `id_` VARCHAR(128) NOT NULL,
  `proc_inst_id_` VARCHAR(128),
  `execution_id_` VARCHAR(128),
  `task_id_` VARCHAR(128),
  `name_` VARCHAR(510) NOT NULL,
  `var_type_` VARCHAR(200),
  `rev_` INT,
  `bytearray_id_` VARCHAR(128),
  `double_` DECIMAL(38,10),
  `long_` DECIMAL(19,0),
  `text_` VARCHAR(4000),
  `text2_` VARCHAR(4000),
  `create_time_` DATETIME(6),
  `last_updated_time_` DATETIME(6),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_comment` (
  `id_` VARCHAR(128) NOT NULL,
  `type_` VARCHAR(510),
  `time_` DATETIME(6) NOT NULL,
  `user_id_` VARCHAR(510),
  `task_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `action_` VARCHAR(510),
  `message_` VARCHAR(4000),
  `full_msg_` LONGBLOB,
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_field` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '字段名称',
  `type` SMALLINT COMMENT '数据类型',
  `input` SMALLINT COMMENT '是否输入',
  `default_value` VARCHAR(1000) COMMENT '固定默认值',
  `empty_default_value` VARCHAR(1000) COMMENT '为空默认值',
  `status` SMALLINT COMMENT '状态',
  `p_id` VARCHAR(64) COMMENT '上级字段',
  `svc_def_code` VARCHAR(64) COMMENT '决策服务定义',
  `is_output` SMALLINT COMMENT '是否固定输出,0:是,1:否',
  `col_num` SMALLINT COMMENT '所占列数',
  `is_hidden` SMALLINT COMMENT '是否隐藏(0:否)',
  `is_lib_index` SMALLINT COMMENT '是否指标库指标,1:是,0:否',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_biz_param` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '参数编号',
  `name` VARCHAR(100) COMMENT '参数名称',
  `value` VARCHAR(512) COMMENT '值',
  `options` LONGTEXT COMMENT '选项',
  `type` SMALLINT COMMENT '字段类型',
  `org_no` VARCHAR(64) COMMENT '机构号',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务参数';

CREATE TABLE `de_di_experiment_data` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `data` LONGTEXT COMMENT '数据内容',
  `dataset_id` VARCHAR(64) COMMENT '数据集ID',
  `real_val` SMALLINT COMMENT '是否为坏样本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验数据';

CREATE TABLE `de_di_node` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(100) COMMENT '节点名称',
  `type` SMALLINT COMMENT '节点类型',
  `p_x` VARCHAR(32) COMMENT '位置x',
  `p_y` VARCHAR(32) COMMENT '位置y',
  `width` VARCHAR(32) COMMENT '宽',
  `height` VARCHAR(32) COMMENT '高',
  `flow_id` VARCHAR(64) COMMENT '流程编号',
  `pkg_id` VARCHAR(64) COMMENT '规则包',
  `model_code` VARCHAR(64) COMMENT '模型编号',
  `input` VARCHAR(128) COMMENT '入参映射中间遍历编号',
  `output` VARCHAR(128) COMMENT '出参映射中间遍历编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_execution_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '内部交易流水',
  `tran_no` VARCHAR(64) COMMENT '外部交易流水',
  `in_json` LONGTEXT COMMENT '输入json',
  `out_json` LONGTEXT COMMENT '输出json',
  `status` SMALLINT COMMENT '执行状态',
  `start_date` DATETIME COMMENT '开始时间',
  `time` DECIMAL(20,0) COMMENT '执行秒数',
  `svc_def_code` VARCHAR(64) COMMENT '服务编号',
  `version` INT COMMENT '版本',
  `org_no` VARCHAR(64) COMMENT '机构',
  `temp_json` LONGTEXT COMMENT '中间变量json',
  `scores_json` LONGTEXT COMMENT '评分json',
  `server_mark` VARCHAR(32) COMMENT '执行服务器ip',
  `prediction_rs` CHAR(2) COMMENT '预测结果',
  `desire_rs` CHAR(2) COMMENT '期望结果',
  `error_msg` VARCHAR(512) COMMENT '错误信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_role_dept` (
  `role_id` DECIMAL(38,0) NOT NULL,
  `dept_id` DECIMAL(38,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_experiment_sc_detail` (
  `condition_value` VARCHAR(256) COMMENT '命中条件',
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `index_code` VARCHAR(64) COMMENT '指标编号',
  `index_name` VARCHAR(512) COMMENT '指标名称',
  `item_id` VARCHAR(64) COMMENT '评分项id',
  `ord` BIGINT COMMENT '命中序号',
  `score` INT COMMENT '命中分值',
  `score_card_log_id` VARCHAR(64) COMMENT '评分卡日志id',
  `weight_score` INT COMMENT '命中权重分',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验评分卡执行明细';

CREATE TABLE `de_di_test_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `svc_id` VARCHAR(64) COMMENT '服务id',
  `test_time` DATETIME NOT NULL COMMENT '测试时间',
  `error_cnt` INT COMMENT '未通过案例数量',
  `message` LONGTEXT COMMENT '错误信息',
  `error_id` LONGTEXT COMMENT '未通过案例id',
  `case_status` SMALLINT COMMENT '案例测试日志状态',
  `org_no` VARCHAR(64) COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_procdef_info` (
  `id_` VARCHAR(128) NOT NULL,
  `proc_def_id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `info_json_id_` VARCHAR(128),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_procdef_info` ADD CONSTRAINT `act_fk_info_json_ba` FOREIGN KEY (`info_json_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_procdef_info` ADD CONSTRAINT `act_fk_info_procdef` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_field_used` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `field_code` VARCHAR(66),
  `entity_id` VARCHAR(64) COMMENT '关联实体主键',
  `type` SMALLINT COMMENT '关联类型',
  `svc_id` VARCHAR(64) COMMENT '决策服务主键',
  `svc_code` VARCHAR(64) COMMENT '决策服务编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_tmpl_svc_def_ref` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `rule_template_code` VARCHAR(64) COMMENT '规则模板主键',
  `svc_def_code` VARCHAR(64) COMMENT '服务模板主键',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_experiment_sc_log` (
  `result_id` VARCHAR(64) COMMENT '执行日志id',
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `score_card_id` VARCHAR(64) COMMENT '评分卡id',
  `total` INT COMMENT '总分',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验评分卡执行记录';

CREATE TABLE `df_fun_param` (
  `id` VARCHAR(128) NOT NULL,
  `code` VARCHAR(128),
  `name` VARCHAR(200),
  `ord` BIGINT NOT NULL,
  `pid` VARCHAR(128),
  `is_multi` BIGINT NOT NULL,
  `type` BIGINT NOT NULL,
  `options` LONGTEXT,
  `function_id` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_link` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `src` VARCHAR(64) COMMENT '源节点',
  `dest` VARCHAR(64) COMMENT '目标节点',
  `c_script` LONGTEXT,
  `c_view` LONGTEXT,
  `desc_info` VARCHAR(100) COMMENT '描述',
  `p_x` VARCHAR(32) COMMENT '位置x',
  `p_y` VARCHAR(32) COMMENT '位置y',
  `width` VARCHAR(32) COMMENT '宽',
  `height` VARCHAR(32) COMMENT '高',
  `s_p` VARCHAR(128) COMMENT '源连接点位置',
  `t_p` VARCHAR(128) COMMENT '目标连接点位置',
  `flow_id` VARCHAR(64) COMMENT '流程编号',
  `points` VARCHAR(256) COMMENT '连线轨迹',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_config_process` (
  `id` VARCHAR(128) NOT NULL COMMENT '主键',
  `mark` VARCHAR(128) COMMENT '系统标识',
  `task_name` VARCHAR(64) COMMENT '任务名称',
  `task_type` SMALLINT COMMENT '任务类型',
  `exe_cycle` SMALLINT COMMENT '执行周期',
  `cycle_num` BIGINT COMMENT '周期数',
  `exe_script` LONGTEXT COMMENT '执行脚本',
  `pre_task` VARCHAR(64) COMMENT '前置任务',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置处理';

CREATE TABLE `de_di_name_list` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(256) COMMENT '名单名称',
  `type` SMALLINT COMMENT '名单类别',
  `org_no` VARCHAR(64) COMMENT '机构号',
  `cate_id` VARCHAR(64) COMMENT '分类id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='名单表';

CREATE TABLE `lsp_role` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '角色id',
  `role_name` VARCHAR(40) NOT NULL COMMENT '角色名称',
  `role_code` VARCHAR(40) COMMENT '角色编码',
  `description` VARCHAR(510) COMMENT '描述',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色';

CREATE TABLE `df_interface_header` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键ID',
  `interface_id` BIGINT NOT NULL COMMENT '接口id',
  `code` VARCHAR(510) NOT NULL COMMENT '代码',
  `name` VARCHAR(510) NOT NULL COMMENT '名称',
  `field_type` VARCHAR(20) NOT NULL COMMENT '字段类型',
  `default_value_type` VARCHAR(4) COMMENT '默认值类型',
  `default_value` VARCHAR(510) COMMENT '默认值',
  `remark` VARCHAR(510) COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_detail` (
  `id_` VARCHAR(128) NOT NULL,
  `type_` VARCHAR(510) NOT NULL,
  `proc_inst_id_` VARCHAR(128),
  `execution_id_` VARCHAR(128),
  `task_id_` VARCHAR(128),
  `act_inst_id_` VARCHAR(128),
  `name_` VARCHAR(510) NOT NULL,
  `var_type_` VARCHAR(128),
  `rev_` INT,
  `time_` DATETIME(6) NOT NULL,
  `bytearray_id_` VARCHAR(128),
  `double_` DECIMAL(38,10),
  `long_` DECIMAL(19,0),
  `text_` VARCHAR(4000),
  `text2_` VARCHAR(4000),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_derive_field_his` (
  `id` BIGINT NOT NULL,
  `old_id` BIGINT,
  `aggregate_function` VARCHAR(128),
  `code` VARCHAR(1020),
  `iterator` BIGINT,
  `name` VARCHAR(1020),
  `df_script` LONGTEXT,
  `df_json` LONGTEXT,
  `status` VARCHAR(8),
  `type` VARCHAR(8),
  `interface_id` BIGINT,
  `distinct_field` VARCHAR(144),
  `data_type` VARCHAR(8),
  `dept_id` VARCHAR(144),
  `html` LONGTEXT,
  `version` INT,
  `fields` VARCHAR(2048),
  `default_value` VARCHAR(400),
  `bits` INT,
  `distinct_field_id` BIGINT COMMENT '去重字段id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_fun` (
  `id` BIGINT NOT NULL,
  `code` VARCHAR(1020) NOT NULL,
  `name` VARCHAR(200),
  `status` BIGINT,
  `wr` BIGINT,
  `return_type` BIGINT,
  `return_option` LONGTEXT,
  `ord` DECIMAL(38,0) NOT NULL,
  `aggregate` VARCHAR(8),
  `system` VARCHAR(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_evt_log` (
  `log_nr_` DECIMAL(19,0) NOT NULL,
  `type_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `execution_id_` VARCHAR(128),
  `task_id_` VARCHAR(128),
  `time_stamp_` DATETIME(6) NOT NULL,
  `user_id_` VARCHAR(510),
  `data_` LONGBLOB,
  `lock_owner_` VARCHAR(510),
  `lock_time_` DATETIME(6),
  `is_processed_` TINYINT DEFAULT '0',
  PRIMARY KEY (`log_nr_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_job_log` (
  `job_log_id` DECIMAL(38,0) NOT NULL,
  `job_name` VARCHAR(256) NOT NULL,
  `job_group` VARCHAR(256) NOT NULL,
  `invoke_target` VARCHAR(2000) NOT NULL,
  `job_message` VARCHAR(2000),
  `status` CHAR(4),
  `exception_info` LONGTEXT,
  `create_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_param` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '参数编号',
  `name` VARCHAR(100) COMMENT '参数名称',
  `ord` SMALLINT COMMENT '序号',
  `pid` VARCHAR(64) COMMENT '上级编号',
  `is_multi` SMALLINT COMMENT '是否可多选',
  `type` SMALLINT COMMENT '字段类型',
  `options` LONGTEXT COMMENT '选项',
  `function_id` VARCHAR(64) COMMENT '函数编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_scheduled_task` (
  `id` VARCHAR(128) NOT NULL COMMENT '主键',
  `task_name` VARCHAR(128) COMMENT '任务名称',
  `svc_code` VARCHAR(128) COMMENT '决策服务编号',
  `org_no` VARCHAR(128) COMMENT '当前机构号',
  `version` INT COMMENT '版本号',
  `cron` VARCHAR(128) COMMENT '定时表达式',
  `status` SMALLINT COMMENT '任务状态',
  `input_file` VARCHAR(128) COMMENT '输入文件路径',
  `output_file` VARCHAR(128) COMMENT '输出文件路径',
  `input_script` LONGTEXT,
  `output_script` LONGTEXT,
  `owner` VARCHAR(128) COMMENT '处理器服务编号',
  `creator` VARCHAR(64) COMMENT '创建者',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lsp_organ` (
  `id` VARCHAR(104) NOT NULL COMMENT '机构id',
  `name` VARCHAR(100) NOT NULL COMMENT '机构名称',
  `parent_id` VARCHAR(104) COMMENT '上级机构id',
  `code` VARCHAR(60) COMMENT '机构号',
  `tree_path` VARCHAR(510) COMMENT '树结构',
  `sort_value` BIGINT COMMENT '排序',
  `address` VARCHAR(100) COMMENT '地址',
  `phone` VARCHAR(22) COMMENT '电话',
  `status` SMALLINT COMMENT '状态（1正常 0停用）',
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME,
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='组织机构';

CREATE TABLE `de_di_model_field` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '字段名称',
  `type` SMALLINT COMMENT '数据类型',
  `input` SMALLINT COMMENT '是否输入',
  `default_value` VARCHAR(1000) COMMENT '固定默认值',
  `empty_default_value` VARCHAR(1000) COMMENT '为空默认值',
  `status` SMALLINT COMMENT '状态',
  `p_id` VARCHAR(64) COMMENT '上级字段',
  `def_code` VARCHAR(64) COMMENT '服务定义',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型字段';

CREATE TABLE `de_di_decision_svc_def_cate` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(64) COMMENT '分类名称',
  `org_no` VARCHAR(64) COMMENT '机构号',
  `p_id` VARCHAR(64) COMMENT '上级分类id',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_link_src` (
  `id` BIGINT NOT NULL,
  `src_code` VARCHAR(400) NOT NULL,
  `src_name` VARCHAR(400) NOT NULL,
  `src_id` BIGINT,
  `type` VARCHAR(8) NOT NULL,
  `library_id` BIGINT NOT NULL,
  `create_time` DATETIME(6),
  `create_user` VARCHAR(120)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_score_card_detail` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `item_id` VARCHAR(64) COMMENT '评分项id',
  `index_code` VARCHAR(64) COMMENT '指标编号',
  `index_name` VARCHAR(512) COMMENT '指标名称',
  `ord` BIGINT COMMENT '命中序号',
  `condition_value` VARCHAR(256) COMMENT '命中条件',
  `score` INT COMMENT '命中分值',
  `weight_score` INT COMMENT '命中权重分',
  `score_card_log_id` VARCHAR(64) COMMENT '评分卡日志id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评分卡执行明细';

CREATE TABLE `de_di_decision_post` (
  `code` VARCHAR(64) NOT NULL COMMENT '岗位编号',
  `name` VARCHAR(128) COMMENT '岗位名称',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='策略岗位表';

CREATE TABLE `df_dict_data` (
  `dict_code` DECIMAL(38,0) NOT NULL COMMENT '字典编码',
  `dict_sort` BIGINT COMMENT '字典排序',
  `dict_label` VARCHAR(400) COMMENT '字典标签',
  `dict_value` VARCHAR(400) COMMENT '字典键值',
  `dict_type` VARCHAR(400) COMMENT '字典类型',
  `css_class` VARCHAR(400) COMMENT '样式属性（其他样式扩展）',
  `list_class` VARCHAR(400) COMMENT '表格回显样式',
  `is_default` CHAR(4) COMMENT '是否默认（Y是 N否）',
  `status` CHAR(4) COMMENT '状态（0正常 1停用）',
  `create_by` VARCHAR(256) COMMENT '创建者',
  `create_time` DATETIME(6) COMMENT '创建时间',
  `update_by` VARCHAR(256) COMMENT '更新者',
  `update_time` DATETIME(6) COMMENT '更新时间',
  `remark` VARCHAR(2000) COMMENT '备注',
  `filter` VARCHAR(1020) COMMENT '过滤条件',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典数据表';

CREATE TABLE `df_query_condition` (
  `id` VARCHAR(256) NOT NULL COMMENT '主键',
  `interface_id` DECIMAL(19,0) NOT NULL COMMENT '关联接口id',
  `field_name` VARCHAR(200) NOT NULL COMMENT '字段名',
  `operator` VARCHAR(40) COMMENT '运算符（= ,!= 或 <> 不等于 ,> ,< ,>= ,<= ,LIKE,NOT LIKE,IN,NOT IN）',
  `logic_operator` VARCHAR(16) DEFAULT 'AND' COMMENT '逻辑符（AND/OR）',
  `is_required` TINYINT DEFAULT '0' COMMENT '是否必填（1必填/0可选）',
  `order_num` BIGINT COMMENT '条件排序号',
  `parent_id` VARCHAR(256) NOT NULL DEFAULT '0' COMMENT '默认0',
  `function_expression` VARCHAR(400) COMMENT '字段函数表达式，如：to_date(?, \'yyyy-MM-dd\')',
  `function_params` VARCHAR(1020) COMMENT '函数参数，JSON格式，如：["create_time"]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='接口条件表';

CREATE TABLE `df_field_monitoring` (
  `id` BIGINT NOT NULL COMMENT '主键-自增',
  `field_id` BIGINT NOT NULL COMMENT '指标id',
  `app_code` VARCHAR(510) NOT NULL COMMENT 'appCode',
  `not_empty` CHAR(2) COMMENT '非空:Y-是,N-否',
  `special_values` VARCHAR(510) COMMENT '特殊值(逗号隔开)',
  `enums` VARCHAR(510) COMMENT '枚举(逗号隔开)',
  `status` CHAR(2) COMMENT '状态:1-有效,0-无效',
  `create_user` DECIMAL(20,0) COMMENT '创建人',
  `create_time` DATETIME COMMENT '创建时间',
  `update_user` DECIMAL(20,0) COMMENT '修改人',
  `update_time` DATETIME COMMENT '修改时间',
  `remark` VARCHAR(510) COMMENT '备注',
  `job_id` DECIMAL(20,0) COMMENT '任务id',
  `last_execution_time` DATETIME COMMENT '上次任务执行时间',
  `gap` BIGINT COMMENT '监控间隔(分钟)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标限制表';

CREATE TABLE `act_ge_bytearray` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `name_` VARCHAR(510),
  `deployment_id_` VARCHAR(128),
  `bytes_` LONGBLOB,
  `generated_` TINYINT,
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ge_bytearray` ADD CONSTRAINT `act_fk_bytearr_depl` FOREIGN KEY (`deployment_id_`) REFERENCES `act_re_deployment`(`id_`);

CREATE TABLE `de_di_case_hit_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `element_id` VARCHAR(64) COMMENT '命中组件id',
  `name` VARCHAR(512) COMMENT '命中组件名称',
  `ord` BIGINT COMMENT '组件序号',
  `type` VARCHAR(32) COMMENT '命中类型',
  `position` VARCHAR(32) COMMENT '命中位置行数',
  `case_data_log_id` VARCHAR(64) COMMENT '测试数据记录主键',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_model_dict` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '名称',
  `f_id` VARCHAR(64) COMMENT '所属字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型字典';

CREATE TABLE `act_ru_variable` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `type_` VARCHAR(510) NOT NULL,
  `name_` VARCHAR(510) NOT NULL,
  `execution_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `task_id_` VARCHAR(128),
  `bytearray_id_` VARCHAR(128),
  `double_` DECIMAL(38,10),
  `long_` DECIMAL(19,0),
  `text_` VARCHAR(4000),
  `text2_` VARCHAR(4000),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_variable` ADD CONSTRAINT `act_fk_var_bytearray` FOREIGN KEY (`bytearray_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_ru_variable` ADD CONSTRAINT `act_fk_var_exe` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_variable` ADD CONSTRAINT `act_fk_var_procinst` FOREIGN KEY (`proc_inst_id_`) REFERENCES `act_ru_execution`(`id_`);

CREATE TABLE `act_ru_task` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `execution_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `name_` VARCHAR(510),
  `business_key_` VARCHAR(255),
  `parent_task_id_` VARCHAR(128),
  `description_` VARCHAR(4000),
  `task_def_key_` VARCHAR(510),
  `owner_` VARCHAR(510),
  `assignee_` VARCHAR(510),
  `delegation_` VARCHAR(128),
  `priority_` INT,
  `create_time_` DATETIME(6),
  `due_date_` DATETIME(6),
  `category_` VARCHAR(510),
  `suspension_state_` INT,
  `tenant_id_` VARCHAR(510) DEFAULT '',
  `form_key_` VARCHAR(510),
  `claim_time_` DATETIME(6),
  `app_version_` INT,
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_task` ADD CONSTRAINT `act_fk_task_exe` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_task` ADD CONSTRAINT `act_fk_task_procinst` FOREIGN KEY (`proc_inst_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_task` ADD CONSTRAINT `act_fk_task_procdef` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_experiment_group` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(256) COMMENT '分组名称',
  `svc_id` VARCHAR(64) COMMENT '决策服务id',
  `dataset_id` VARCHAR(64) COMMENT '数据集id',
  `experiment_id` VARCHAR(64) COMMENT '实验id',
  `html` LONGTEXT COMMENT '坏样本计算规则页面',
  `script` LONGTEXT COMMENT '坏样本计算规则脚本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验分组';

CREATE TABLE `df_data_source` (
  `source_id` BIGINT NOT NULL,
  `source_type` VARCHAR(40) NOT NULL,
  `source_code` VARCHAR(256) NOT NULL,
  `source_name` VARCHAR(1020) NOT NULL,
  `status` VARCHAR(8) NOT NULL,
  `access_method` VARCHAR(1020) NOT NULL,
  `transaction_code` VARCHAR(1020) NOT NULL,
  `param_signature` VARCHAR(40),
  `data_encrypt` VARCHAR(40),
  `encrypt_encoding` VARCHAR(1020),
  `file_id` VARCHAR(256),
  `create_time` DATETIME(6),
  `create_by` VARCHAR(128),
  `update_time` DATETIME(6),
  `update_by` VARCHAR(128),
  `organ_id` VARCHAR(128),
  `organ_ids` VARCHAR(1020),
  `cache_enable` VARCHAR(10) DEFAULT 'N' COMMENT '缓存是否启用(Y:是,N:否)',
  `cache_duration` INT DEFAULT '-1' COMMENT '缓存时效(秒)',
  `timeout_enable` VARCHAR(10) DEFAULT 'N' COMMENT '数据超时是否启用(Y:是,N:否)',
  `timeout_duration` INT DEFAULT '-1' COMMENT '数据超时时间(毫秒)',
  `retry_count` INT DEFAULT '-1' COMMENT '重发次数',
  `retry_enable` VARCHAR(10) DEFAULT 'N' COMMENT '重发机制是否启用(Y:是,N:否)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_test_case` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `svc_code` VARCHAR(64) COMMENT '服务编号',
  `name` VARCHAR(256) COMMENT '案例名称',
  `data` LONGTEXT COMMENT '案例数据',
  `html` LONGTEXT COMMENT '验证规则页面',
  `script` LONGTEXT COMMENT '验证规则脚本',
  `create_time` DATETIME COMMENT '创建时间',
  `org_no` VARCHAR(64) COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lsp_menu` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '编号',
  `parent_id` DECIMAL(20,0) COMMENT '所属上级',
  `name` VARCHAR(40) NOT NULL COMMENT '名称',
  `url_perm` VARCHAR(128) COMMENT '接口权限标识',
  `type` SMALLINT NOT NULL COMMENT '类型(0:目录,1:菜单,2:按钮)',
  `path` VARCHAR(200) COMMENT '路由地址',
  `component` VARCHAR(200) COMMENT '组件路径',
  `perms` VARCHAR(200) COMMENT '权限标识',
  `icon` VARCHAR(200) COMMENT '图标',
  `sort_value` BIGINT COMMENT '排序',
  `status` SMALLINT COMMENT '状态(0:禁止,1:正常)',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）',
  `mark` VARCHAR(64) COMMENT '系统标识',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单表';

CREATE TABLE `de_di_case_data_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `tran_no` VARCHAR(64) COMMENT '外部交易流水',
  `in_json` LONGTEXT COMMENT '输入json',
  `out_json` LONGTEXT COMMENT '输出json',
  `status` SMALLINT COMMENT '执行状态',
  `start_date` DATETIME NOT NULL COMMENT '开始时间',
  `time` DECIMAL(20,0) COMMENT '执行秒数',
  `version` INT COMMENT '版本',
  `svc_def_code` VARCHAR(64) COMMENT '服务编号',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `data_source` SMALLINT COMMENT '案例数据来源',
  `test_log_id` VARCHAR(64) COMMENT '测试案例库日志id',
  `temp_json` LONGTEXT COMMENT '中间变量json',
  `scores_json` LONGTEXT COMMENT '评分json',
  `error_msg` VARCHAR(512) COMMENT '错误信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_decision_svc` (
  `id` VARCHAR(64) NOT NULL,
  `svc_def_code` VARCHAR(64) COMMENT '决策服务定义',
  `version` INT COMMENT '版本',
  `status` SMALLINT COMMENT '状态',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `create_user` VARCHAR(64) COMMENT '创建用户',
  `start_user` VARCHAR(64) COMMENT '启用用户',
  `end_user` VARCHAR(64) COMMENT '停用用户',
  `create_time` DATETIME COMMENT '创建时间',
  `start_time` DATETIME COMMENT '启用时间',
  `end_time` DATETIME COMMENT '停用时间',
  `error_msg` LONGTEXT COMMENT '错误提示',
  `shunts` BIGINT COMMENT '分流比例',
  `review_user` VARCHAR(64),
  `review_time` DATETIME,
  `ref_version` INT COMMENT '导出基于版本',
  `name` VARCHAR(64) COMMENT '服务名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_index_library_log` (
  `id` BIGINT NOT NULL,
  `library_id` BIGINT NOT NULL,
  `field_id` BIGINT NOT NULL,
  `library_version` INT,
  `field_version` INT,
  `create_time` DATETIME(6),
  `create_user` DECIMAL(38,0),
  `field_status` VARCHAR(2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_flow` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `dsp_code` VARCHAR(64) COMMENT '调度编号',
  `version` INT COMMENT '版本',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `status` SMALLINT COMMENT '状态',
  `create_user` VARCHAR(64) COMMENT '创建用户',
  `start_user` VARCHAR(64) COMMENT '启用用户',
  `end_user` VARCHAR(64) COMMENT '停用用户',
  `create_time` DATETIME COMMENT '创建时间',
  `start_time` DATETIME COMMENT '启用时间',
  `end_time` DATETIME COMMENT '停用时间',
  `error_msg` LONGTEXT COMMENT '错误提示',
  `shunts` BIGINT COMMENT '分流比例',
  `review_user` VARCHAR(64) COMMENT '复核用户',
  `review_time` DATETIME COMMENT '复核时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_business` (
  `id` BIGINT NOT NULL,
  `name` VARCHAR(1020) NOT NULL,
  `parent_id` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_experiment_result` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `group_id` VARCHAR(64) COMMENT '分组id',
  `data_id` VARCHAR(64) COMMENT '数据id',
  `status` VARCHAR(128) COMMENT '状态',
  `input` LONGTEXT COMMENT '输入',
  `output` LONGTEXT COMMENT '输出',
  `temp` LONGTEXT COMMENT '中间变量',
  `calc` VARCHAR(2) COMMENT '测算结果PN',
  `real_val` VARCHAR(2) COMMENT '真实表现PN',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验结果';

CREATE TABLE `de_di_experiment_dataset` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(256) COMMENT '数据集名称',
  `svc_code` VARCHAR(64) COMMENT '服务编号',
  `create_user` VARCHAR(128) COMMENT '创建人',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `org_no` VARCHAR(64) COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验数据集';

CREATE TABLE `de_di_hit_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(512),
  `type` VARCHAR(32) COMMENT '命中类型',
  `position` VARCHAR(1024) COMMENT '命中位置行数（普通规则:1为正向命中,0为反向命中;决策表:单个数字代表命中行数;多维矩阵:多个数字以空格隔开，代表每个维度位置）',
  `execution_log_id` VARCHAR(64) COMMENT '执行记录编号',
  `element_id` VARCHAR(64),
  `ord` BIGINT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_name_list_cate` (
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(64) COMMENT '分类名称',
  `org_no` VARCHAR(64) COMMENT '机构号',
  `p_id` VARCHAR(64) COMMENT '上级分类id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='名单分类';

CREATE TABLE `de_di_operate_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `operate_type` SMALLINT COMMENT '操作类型',
  `operate_obj` SMALLINT COMMENT '操作对象',
  `request_param` LONGTEXT,
  `operator` VARCHAR(32) COMMENT '操作员',
  `operation_time` DATETIME NOT NULL COMMENT '操作时间',
  `operate_st` SMALLINT COMMENT '操作状态',
  `operate_ip` VARCHAR(32) COMMENT '操作来源ip',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_exe_log` (
  `tran_no` VARCHAR(128) NOT NULL,
  `in_tran_no` VARCHAR(256),
  `app` VARCHAR(80) NOT NULL,
  `version` INT,
  `code` VARCHAR(80) NOT NULL,
  `status` CHAR(4) NOT NULL,
  `params` LONGTEXT,
  `input` LONGTEXT,
  `resp_code` VARCHAR(40),
  `resp_msg` VARCHAR(4000),
  `cb_url` VARCHAR(800),
  `result` LONGTEXT,
  `req_time` DATETIME(6),
  `resp_time` DATETIME(6),
  `create_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_model_svc` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `def_code` VARCHAR(64) COMMENT '决策服务定义',
  `version` INT COMMENT '版本',
  `status` SMALLINT COMMENT '状态',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `create_user` VARCHAR(64) COMMENT '创建用户',
  `start_user` VARCHAR(64) COMMENT '启用用户',
  `end_user` VARCHAR(64) COMMENT '停用用户',
  `create_time` DATETIME COMMENT '创建时间',
  `start_time` DATETIME COMMENT '启用时间',
  `end_time` DATETIME COMMENT '停用时间',
  `error_msg` LONGTEXT COMMENT '错误提示',
  `shunts` BIGINT COMMENT '分流比例',
  `review_user` VARCHAR(64) COMMENT '复核人员',
  `review_time` DATETIME COMMENT '复核时间',
  `pmml` LONGTEXT COMMENT 'pmml',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型服务';

CREATE TABLE `lsp_role_menu` (
  `id` DECIMAL(20,0) NOT NULL,
  `role_id` DECIMAL(20,0) NOT NULL,
  `menu_id` DECIMAL(20,0) NOT NULL,
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色菜单';

CREATE TABLE `de_di_dsp_proc` (
  `id` VARCHAR(64) COMMENT '主键',
  `type` SMALLINT COMMENT '处理器类型',
  `node_id` VARCHAR(64) COMMENT '节点编号',
  `code` VARCHAR(64) COMMENT '处理器编号',
  `sync` SMALLINT COMMENT '是否同步',
  `mapping_script` LONGTEXT COMMENT '映射脚本',
  `ref_lib_code` VARCHAR(64) COMMENT '关联指标库编号',
  `flow_id` VARCHAR(64) COMMENT '流程id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_derive_temp_result` (
  `template_id` BIGINT NOT NULL COMMENT '模版ID',
  `derive_id` BIGINT NOT NULL COMMENT '衍生指标ID',
  `params` VARCHAR(1024) COMMENT '参数列表(逗号隔开)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='衍生指标模板返回结果表';

CREATE TABLE `df_derive_field` (
  `id` BIGINT NOT NULL,
  `aggregate_function` VARCHAR(128),
  `code` VARCHAR(1020) NOT NULL,
  `iterator` BIGINT,
  `name` VARCHAR(1020) NOT NULL,
  `df_script` LONGTEXT,
  `df_json` LONGTEXT,
  `status` VARCHAR(8) NOT NULL,
  `type` VARCHAR(8) NOT NULL,
  `interface_id` BIGINT NOT NULL,
  `distinct_field` VARCHAR(144),
  `data_type` VARCHAR(8) NOT NULL,
  `dept_id` VARCHAR(144),
  `html` LONGTEXT,
  `fields` VARCHAR(2048),
  `version` INT,
  `organ_id` VARCHAR(128),
  `organ_ids` VARCHAR(1020),
  `create_by` VARCHAR(128),
  `create_time` DATETIME,
  `default_value` VARCHAR(400),
  `bits` BIGINT,
  `update_by` VARCHAR(1020),
  `update_time` DATETIME,
  `distinct_field_id` BIGINT COMMENT '去重字段id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_actinst` (
  `id_` VARCHAR(128) NOT NULL,
  `proc_def_id_` VARCHAR(128) NOT NULL,
  `proc_inst_id_` VARCHAR(128) NOT NULL,
  `execution_id_` VARCHAR(128) NOT NULL,
  `act_id_` VARCHAR(510) NOT NULL,
  `task_id_` VARCHAR(128),
  `call_proc_inst_id_` VARCHAR(128),
  `act_name_` VARCHAR(510),
  `act_type_` VARCHAR(510) NOT NULL,
  `assignee_` VARCHAR(510),
  `start_time_` DATETIME(6) NOT NULL,
  `end_time_` DATETIME(6),
  `duration_` DECIMAL(19,0),
  `delete_reason_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_job` (
  `job_id` DECIMAL(38,0) NOT NULL,
  `job_name` VARCHAR(256) NOT NULL,
  `job_group` VARCHAR(256) NOT NULL,
  `invoke_target` VARCHAR(2000) NOT NULL,
  `cron_expression` VARCHAR(1020),
  `misfire_policy` VARCHAR(80),
  `concurrent` CHAR(4),
  `status` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_decision_lib` (
  `id` VARCHAR(64) NOT NULL COMMENT '决策库ID',
  `name` VARCHAR(100) COMMENT '决策库名称',
  `svc_def_code` VARCHAR(64) COMMENT '归属决策服务',
  `create_time` DATETIME COMMENT '创建时间',
  `org_no` VARCHAR(64) COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_flow` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `svc_id` VARCHAR(64) COMMENT '决策服务',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_log` (
  `id` VARCHAR(64) NOT NULL,
  `tran_no` VARCHAR(64),
  `create_time` DATETIME,
  `start_time` DATETIME,
  `end_time` DATETIME,
  `status` SMALLINT,
  `dispatcher_code` VARCHAR(64),
  `version` INT,
  `input` LONGTEXT,
  `output` LONGTEXT,
  `owner` VARCHAR(64),
  `error_code` VARCHAR(64),
  `error_msg` VARCHAR(512),
  `cnt` SMALLINT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `gen_table` (
  `table_id` DECIMAL(38,0) NOT NULL,
  `table_name` VARCHAR(800),
  `table_comment` VARCHAR(2000),
  `class_name` VARCHAR(400),
  `tpl_category` VARCHAR(800),
  `package_name` VARCHAR(400),
  `module_name` VARCHAR(120),
  `business_name` VARCHAR(120),
  `function_name` VARCHAR(200),
  `function_author` VARCHAR(200),
  `gen_type` CHAR(4),
  `gen_path` VARCHAR(800),
  `options` VARCHAR(4000),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ge_property` (
  `name_` VARCHAR(128) NOT NULL,
  `value_` VARCHAR(600),
  `rev_` INT,
  PRIMARY KEY (`name_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_data_source_db_info` (
  `id` BIGINT NOT NULL,
  `source_id` BIGINT,
  `name` VARCHAR(1020) NOT NULL,
  `db_type` VARCHAR(256) NOT NULL,
  `db_host` VARCHAR(1020) NOT NULL,
  `db_port` BIGINT NOT NULL,
  `db_name` VARCHAR(1020) NOT NULL,
  `db_username` VARCHAR(400) NOT NULL,
  `db_password` VARCHAR(400) NOT NULL,
  `max_size` BIGINT,
  `minimum_idle` BIGINT,
  `idle_timeout` BIGINT,
  `conn_timeout` BIGINT,
  `user_auth_db_name` VARCHAR(128),
  `db_schema` VARCHAR(1020)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_dict_data` (
  `dict_code` DECIMAL(38,0) NOT NULL,
  `dict_sort` BIGINT,
  `dict_label` VARCHAR(400),
  `dict_value` VARCHAR(400),
  `dict_type` VARCHAR(400),
  `css_class` VARCHAR(400),
  `list_class` VARCHAR(400),
  `is_default` CHAR(4),
  `status` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000),
  `filter` VARCHAR(1020)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_timer_job` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `type_` VARCHAR(510) NOT NULL,
  `lock_exp_time_` DATETIME(6),
  `lock_owner_` VARCHAR(510),
  `exclusive_` TINYINT,
  `execution_id_` VARCHAR(128),
  `process_instance_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `retries_` INT,
  `exception_stack_id_` VARCHAR(128),
  `exception_msg_` VARCHAR(4000),
  `duedate_` DATETIME(6),
  `repeat_` VARCHAR(510),
  `handler_type_` VARCHAR(510),
  `handler_cfg_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_timer_job` ADD CONSTRAINT `act_fk_tjob_exception` FOREIGN KEY (`exception_stack_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_ru_timer_job` ADD CONSTRAINT `act_fk_tjob_execution` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_timer_job` ADD CONSTRAINT `act_fk_tjob_process_instance` FOREIGN KEY (`process_instance_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_timer_job` ADD CONSTRAINT `act_fk_tjob_proc_def` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_fun_svc_def_ref` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `fun_code` VARCHAR(64) COMMENT '函数主键',
  `svc_def_code` VARCHAR(64) COMMENT '服务模板主键',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_experiment_worth` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(128) COMMENT '名称',
  `experiment_id` VARCHAR(64) COMMENT '实验id',
  `html` LONGTEXT COMMENT '汇总值页面',
  `script` LONGTEXT COMMENT '汇总值脚本',
  `summary_type` INT COMMENT '汇总方式',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实验价值';

CREATE TABLE `df_library_field` (
  `id` BIGINT NOT NULL,
  `library_id` BIGINT NOT NULL,
  `interface_id` VARCHAR(200),
  `field_code` VARCHAR(400) NOT NULL,
  `field_name` VARCHAR(400) NOT NULL,
  `parent_id` BIGINT,
  `type` VARCHAR(8),
  `script` LONGTEXT,
  `json` LONGTEXT,
  `create_time` DATETIME(6),
  `create_user` DECIMAL(38,0),
  `field_type` VARCHAR(1020),
  `length` BIGINT,
  `accuracy` BIGINT,
  `version` INT,
  `status` VARCHAR(8),
  `fields` VARCHAR(2048),
  `html` LONGTEXT,
  `display_type` VARCHAR(8),
  `param_type` CHAR(4),
  `directly_related` VARCHAR(8),
  `sort_order` VARCHAR(8),
  `sort_field` VARCHAR(1020),
  `sort` VARCHAR(8),
  `hierarchy` VARCHAR(1020),
  `preheat` VARCHAR(8),
  `invoked_fields` VARCHAR(255) COMMENT '二次衍生引用的衍生指标id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_name_list_data` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(256) COMMENT '客户名称',
  `type` SMALLINT COMMENT '证件类型',
  `code` VARCHAR(128) COMMENT '证件编号',
  `list_id` VARCHAR(64) COMMENT '名单编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='名单数据表';

CREATE TABLE `lsp_oper_log` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '日志主键',
  `title` VARCHAR(100) COMMENT '模块标题',
  `business_type` VARCHAR(40) COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` VARCHAR(200) COMMENT '方法名称',
  `request_method` VARCHAR(20) COMMENT '请求方式',
  `operator_type` VARCHAR(40) COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` VARCHAR(100) COMMENT '操作人员',
  `dept_name` VARCHAR(100) COMMENT '部门名称',
  `oper_url` VARCHAR(510) COMMENT '请求URL',
  `oper_ip` VARCHAR(256) COMMENT '主机地址',
  `oper_param` LONGTEXT COMMENT '请求参数',
  `json_result` LONGTEXT COMMENT '返回参数',
  `status` BIGINT COMMENT '操作状态（0正常 1异常）',
  `error_msg` LONGTEXT COMMENT '错误消息',
  `oper_time` DATETIME COMMENT '操作时间',
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME,
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志记录';

CREATE TABLE `act_re_deployment` (
  `id_` VARCHAR(128) NOT NULL,
  `name_` VARCHAR(510),
  `category_` VARCHAR(510),
  `key_` VARCHAR(510),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  `deploy_time_` DATETIME(6),
  `engine_version_` VARCHAR(510),
  `version_` INT DEFAULT '1',
  `project_release_version_` VARCHAR(510),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_internal_data_column` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `table_name` VARCHAR(128) NOT NULL COMMENT '表的名称',
  `column_name` VARCHAR(128) NOT NULL COMMENT '列的名称',
  `ordinal_position` BIGINT NOT NULL COMMENT '列的序数位置',
  `column_default` VARCHAR(128) COMMENT '列的默认值',
  `not_null` VARCHAR(6) COMMENT 'Y:不能为NULL，N:可以为NULL',
  `data_type` VARCHAR(128) COMMENT '列的数据类型',
  `length` BIGINT COMMENT '长度',
  `numeric_scale` BIGINT COMMENT '数值类型的小数位数',
  `pri_key` VARCHAR(6) COMMENT '是否主键，Y是N否',
  `auto_increment` VARCHAR(20) COMMENT '是否自增',
  `column_comment` VARCHAR(1024) COMMENT '列的注释'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='列数据信息';

CREATE TABLE `df_user` (
  `user_id` DECIMAL(38,0) NOT NULL,
  `dept_id` DECIMAL(38,0),
  `user_name` VARCHAR(120) NOT NULL,
  `nick_name` VARCHAR(120) NOT NULL,
  `user_type` VARCHAR(8),
  `email` VARCHAR(200),
  `phonenumber` VARCHAR(44),
  `sex` CHAR(4),
  `avatar` VARCHAR(400),
  `password` VARCHAR(400),
  `status` CHAR(4),
  `del_flag` CHAR(4),
  `login_ip` VARCHAR(200),
  `login_date` DATETIME(6),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_step_log` (
  `id` VARCHAR(160) NOT NULL,
  `task_id` VARCHAR(64),
  `status` SMALLINT,
  `node_id` VARCHAR(512),
  `node_nm` VARCHAR(512),
  `processor_id` VARCHAR(64),
  `processor_nm` VARCHAR(512),
  `processor_code` VARCHAR(64),
  `start_time` DATETIME COMMENT '开始时间',
  `end_time` DATETIME COMMENT '结束时间',
  `input` LONGTEXT,
  `output` LONGTEXT,
  `error_code` VARCHAR(64),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_data_encrypt` (
  `id` BIGINT NOT NULL,
  `source_id` BIGINT NOT NULL,
  `encryption_algorithm` VARCHAR(1020) NOT NULL,
  `public_key` LONGTEXT,
  `private_key` LONGTEXT,
  `encryption_type` VARCHAR(1020),
  `created_at` DATETIME(6),
  `updated_at` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_interface` (
  `interface_id` BIGINT NOT NULL COMMENT '主键ID',
  `source_id` BIGINT NOT NULL,
  `biz_type` VARCHAR(80),
  `name` VARCHAR(512) NOT NULL,
  `code` VARCHAR(512) NOT NULL,
  `url` LONGTEXT NOT NULL,
  `req_method` VARCHAR(80) NOT NULL,
  `req_format` VARCHAR(80) NOT NULL,
  `res_format` VARCHAR(80),
  `success_field` VARCHAR(800),
  `success_value` VARCHAR(80),
  `table_name` VARCHAR(1020),
  `status` VARCHAR(8),
  `create_time` DATETIME(6),
  `create_by` VARCHAR(128),
  `update_time` DATETIME(6),
  `update_by` VARCHAR(128),
  `organ_id` VARCHAR(128),
  `organ_ids` VARCHAR(1020),
  `cache_enable` VARCHAR(40) DEFAULT 'N',
  `cache_duration` INT DEFAULT '-1',
  `timeout_enable` VARCHAR(40) DEFAULT 'N',
  `timeout_duration` INT DEFAULT '-1',
  `retry_enable` VARCHAR(40) DEFAULT 'N',
  `retry_count` INT DEFAULT '-1',
  `groovy_script` LONGTEXT,
  `output_data_preprocessing` LONGTEXT,
  PRIMARY KEY (`interface_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_param` (
  `id` VARCHAR(128) NOT NULL COMMENT '主键',
  `code` VARCHAR(128) COMMENT '参数编号',
  `org_no` VARCHAR(128) COMMENT '机构号',
  `name` VARCHAR(128) COMMENT '参数名称',
  `value` VARCHAR(128) COMMENT '参数值',
  `type` SMALLINT COMMENT '字段类型',
  `options` LONGTEXT COMMENT '选项'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统参数表';

CREATE TABLE `de_di_decision_svc_def` (
  `code` VARCHAR(64) NOT NULL COMMENT '决策服务编号',
  `name` VARCHAR(100) COMMENT '规则集名称',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `template` LONGTEXT,
  `status` SMALLINT COMMENT '模板状态',
  `type` SMALLINT COMMENT '模板类型',
  `cate_id` VARCHAR(64) COMMENT '模板分类id',
  `index_lib_id` VARCHAR(64),
  `html` LONGTEXT COMMENT '验证规则页面',
  `script` LONGTEXT COMMENT '验证规则脚本',
  `monitor_field` LONGTEXT COMMENT '监控指标',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_post_permission_ref` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `post_code` VARCHAR(64) NOT NULL COMMENT '岗位编号',
  `svc_code` VARCHAR(128) COMMENT '服务编号',
  `component_range` VARCHAR(6) NOT NULL COMMENT '组件范围(决策流/组件包/组件)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='岗位权限表';

CREATE TABLE `df_config` (
  `config_id` BIGINT NOT NULL COMMENT '参数主键',
  `config_name` VARCHAR(400) COMMENT '参数名称',
  `config_key` VARCHAR(400) COMMENT '参数键名',
  `config_value` VARCHAR(2000) COMMENT '参数键值',
  `config_type` CHAR(4) COMMENT '系统内置（Y是 N否）',
  `create_by` VARCHAR(256) COMMENT '创建者',
  `create_time` DATETIME(6) COMMENT '创建时间',
  `update_by` VARCHAR(256) COMMENT '更新者',
  `update_time` DATETIME(6) COMMENT '更新时间',
  `remark` VARCHAR(2000) COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='参数配置表';

CREATE TABLE `df_field_dict` (
  `id` BIGINT NOT NULL,
  `code` VARCHAR(1020) NOT NULL,
  `name` VARCHAR(1020) NOT NULL,
  `field_id` BIGINT NOT NULL,
  `dest_code` VARCHAR(1020),
  `dict_type` CHAR(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_integration` (
  `id_` VARCHAR(128) NOT NULL,
  `execution_id_` VARCHAR(128),
  `process_instance_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `flow_node_id_` VARCHAR(128),
  `created_date_` DATETIME(6),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_integration` ADD CONSTRAINT `act_fk_int_execution` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_integration` ADD CONSTRAINT `act_fk_int_proc_inst` FOREIGN KEY (`process_instance_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_integration` ADD CONSTRAINT `act_fk_int_proc_def` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_task_log` (
  `id` VARCHAR(128) NOT NULL COMMENT '主键',
  `task_id` VARCHAR(128) COMMENT '任务主键',
  `execute_time` DATETIME COMMENT '执行时间',
  `result` VARCHAR(64) COMMENT '执行结果',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_job` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `type_` VARCHAR(510) NOT NULL,
  `lock_exp_time_` DATETIME(6),
  `lock_owner_` VARCHAR(510),
  `exclusive_` TINYINT,
  `execution_id_` VARCHAR(128),
  `process_instance_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `retries_` INT,
  `exception_stack_id_` VARCHAR(128),
  `exception_msg_` VARCHAR(4000),
  `duedate_` DATETIME(6),
  `repeat_` VARCHAR(510),
  `handler_type_` VARCHAR(510),
  `handler_cfg_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_job` ADD CONSTRAINT `act_fk_job_exception` FOREIGN KEY (`exception_stack_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_ru_job` ADD CONSTRAINT `act_fk_job_execution` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_job` ADD CONSTRAINT `act_fk_job_process_instance` FOREIGN KEY (`process_instance_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_job` ADD CONSTRAINT `act_fk_job_proc_def` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_fun` (
  `code` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(100) COMMENT '函数名称',
  `status` SMALLINT COMMENT '状态',
  `wr` SMALLINT COMMENT '无返回值',
  `return_type` SMALLINT COMMENT '返回值类型',
  `return_option` LONGTEXT COMMENT '返回值选项',
  `fun_script` LONGTEXT COMMENT '函数脚本',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_suspended_job` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `type_` VARCHAR(510) NOT NULL,
  `exclusive_` TINYINT,
  `execution_id_` VARCHAR(128),
  `process_instance_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `retries_` INT,
  `exception_stack_id_` VARCHAR(128),
  `exception_msg_` VARCHAR(4000),
  `duedate_` DATETIME(6),
  `repeat_` VARCHAR(510),
  `handler_type_` VARCHAR(510),
  `handler_cfg_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_suspended_job` ADD CONSTRAINT `act_fk_sjob_exception` FOREIGN KEY (`exception_stack_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_ru_suspended_job` ADD CONSTRAINT `act_fk_sjob_execution` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_suspended_job` ADD CONSTRAINT `act_fk_sjob_process_instance` FOREIGN KEY (`process_instance_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_suspended_job` ADD CONSTRAINT `act_fk_sjob_proc_def` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `act_ru_execution` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `proc_inst_id_` VARCHAR(128),
  `business_key_` VARCHAR(510),
  `parent_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `super_exec_` VARCHAR(128),
  `root_proc_inst_id_` VARCHAR(128),
  `act_id_` VARCHAR(510),
  `is_active_` TINYINT,
  `is_concurrent_` TINYINT,
  `is_scope_` TINYINT,
  `is_event_scope_` TINYINT,
  `is_mi_root_` TINYINT,
  `suspension_state_` INT,
  `cached_ent_state_` INT,
  `tenant_id_` VARCHAR(510) DEFAULT '',
  `name_` VARCHAR(510),
  `start_time_` DATETIME(6),
  `start_user_id_` VARCHAR(510),
  `lock_time_` DATETIME(6),
  `is_count_enabled_` TINYINT,
  `evt_subscr_count_` INT,
  `task_count_` INT,
  `job_count_` INT,
  `timer_job_count_` INT,
  `susp_job_count_` INT,
  `deadletter_job_count_` INT,
  `var_count_` INT,
  `id_link_count_` INT,
  `app_version_` INT,
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_execution` ADD CONSTRAINT `act_fk_exe_procinst` FOREIGN KEY (`proc_inst_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_execution` ADD CONSTRAINT `act_fk_exe_parent` FOREIGN KEY (`parent_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_execution` ADD CONSTRAINT `act_fk_exe_super` FOREIGN KEY (`super_exec_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_execution` ADD CONSTRAINT `act_fk_exe_procdef` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `de_di_model_execution_log` (
  `desire_rs` CHAR(2) COMMENT '期望结果',
  `id` VARCHAR(64) NOT NULL COMMENT '内部交易流水',
  `in_json` LONGTEXT COMMENT '输入json',
  `org_no` VARCHAR(64) COMMENT '机构',
  `out_json` LONGTEXT COMMENT '输出json',
  `prediction_rs` CHAR(2) COMMENT '预测结果',
  `scores_json` LONGTEXT COMMENT '评分json',
  `server_mark` VARCHAR(32) COMMENT '执行服务器ip',
  `start_date` DATETIME COMMENT '开始时间',
  `status` SMALLINT COMMENT '执行状态',
  `def_code` VARCHAR(64) COMMENT '服务编号',
  `temp_json` LONGTEXT COMMENT '中间变量json',
  `time` DECIMAL(20,0) COMMENT '执行秒数',
  `tran_no` VARCHAR(64) COMMENT '外部交易流水',
  `version` INT COMMENT '版本',
  `error_msg` VARCHAR(512) COMMENT '错误信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型执行日志';

CREATE TABLE `df_library_field_his` (
  `id` BIGINT NOT NULL,
  `old_id` BIGINT,
  `library_id` BIGINT,
  `interface_id` VARCHAR(200),
  `field_code` VARCHAR(400),
  `field_name` VARCHAR(400),
  `parent_id` BIGINT,
  `type` VARCHAR(8),
  `script` LONGTEXT,
  `json` LONGTEXT,
  `create_time` DATETIME(6),
  `create_user` DECIMAL(38,0),
  `field_type` VARCHAR(1020),
  `length` BIGINT,
  `accuracy` BIGINT,
  `version` INT,
  `status` VARCHAR(8),
  `fields` VARCHAR(2048),
  `html` LONGTEXT,
  `display_type` VARCHAR(8),
  `param_type` CHAR(4),
  `directly_related` VARCHAR(8),
  `sort_order` VARCHAR(8),
  `sort_field` VARCHAR(1020),
  `sort` VARCHAR(8),
  `hierarchy` VARCHAR(1020),
  `preheat` VARCHAR(8)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_backtrack_task_log` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键id',
  `status` VARCHAR(4) COMMENT '状态0-进行中，1-已完成',
  `task_name` VARCHAR(100) NOT NULL COMMENT '回溯任务名称',
  `task_id` DECIMAL(20,0) NOT NULL COMMENT '回溯任务id',
  `create_time` DATETIME COMMENT '创建时间',
  `create_user` VARCHAR(60) COMMENT '创建用户',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回溯任务日志表';

CREATE TABLE `df_backtrack_task` (
  `task_id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `task_name` VARCHAR(100) COMMENT '回溯任务名称',
  `task_type` VARCHAR(4) COMMENT '回溯任务类型: 0-单库测试，1-对比测试',
  `library_id` DECIMAL(20,0) COMMENT '指标库id',
  `library_version` INT COMMENT '版本',
  `compare_library_version` INT COMMENT '对比的版本：对比测试的任务才有值',
  `dataset_id` DECIMAL(20,0) COMMENT '回溯数据集的id',
  `create_time` DATETIME COMMENT '创建时间',
  `create_by` VARCHAR(64) COMMENT '创建用户',
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回溯任务';

CREATE TABLE `df_batch_execute_mapping` (
  `id` DECIMAL(20,0) NOT NULL,
  `task_id` DECIMAL(20,0) COMMENT '任务名称',
  `source_table` VARCHAR(128) COMMENT '源表',
  `source_code` VARCHAR(128) COMMENT '源字段code',
  `target_code` VARCHAR(128) COMMENT '目标字段code',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='批量回溯映射关系';

CREATE TABLE `df_process` (
  `process_id` VARCHAR(128) NOT NULL,
  `category` VARCHAR(1020),
  `sponsor` DECIMAL(38,0),
  `start_date` DATETIME(6),
  `state` CHAR(4),
  `deal_date` DATETIME(6),
  `deal_state` CHAR(4),
  `business_key` VARCHAR(256),
  `process_name` VARCHAR(512)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_identitylink` (
  `id_` VARCHAR(128) NOT NULL,
  `group_id_` VARCHAR(510),
  `type_` VARCHAR(510),
  `user_id_` VARCHAR(510),
  `task_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_identitylink` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `group_id_` VARCHAR(510),
  `type_` VARCHAR(510),
  `user_id_` VARCHAR(510),
  `task_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_identitylink` ADD CONSTRAINT `act_fk_idl_procinst` FOREIGN KEY (`proc_inst_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_identitylink` ADD CONSTRAINT `act_fk_tskass_task` FOREIGN KEY (`task_id_`) REFERENCES `act_ru_task`(`id_`);

ALTER TABLE `act_ru_identitylink` ADD CONSTRAINT `act_fk_athrz_procedef` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `df_link_dest` (
  `id` BIGINT NOT NULL,
  `link_id` BIGINT NOT NULL,
  `dest_code` VARCHAR(400),
  `dest_name` VARCHAR(512),
  `dest_id` BIGINT,
  `library_id` BIGINT,
  `dest_column_id` BIGINT,
  `type` VARCHAR(8) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_file_source` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键id',
  `file_id` VARCHAR(128) NOT NULL COMMENT '文件识别id',
  `file_name` VARCHAR(1024) NOT NULL COMMENT '重命名的文件名称(唯一)',
  `file_source_name` VARCHAR(1024) COMMENT '文件名',
  `file_type` VARCHAR(40) COMMENT '文件类别',
  `del_flag` CHAR(2) COMMENT '删除标志：0-正常，1-已删除',
  `file_path` VARCHAR(1024) NOT NULL COMMENT '文件路径',
  `file_release_user` VARCHAR(64) COMMENT '上传者',
  `file_date` DATETIME COMMENT '上传日期',
  `file_size` VARCHAR(200) COMMENT '文件大小',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文件表';

CREATE TABLE `de_di_decision_element` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `pkg_id` VARCHAR(64) COMMENT '归属包',
  `cate_id` VARCHAR(64) COMMENT '归属分类',
  `ord` INT,
  `name` VARCHAR(100) COMMENT '规则名称',
  `html` LONGTEXT,
  `script` LONGTEXT,
  `status` SMALLINT,
  `template_id` VARCHAR(64),
  `rule_biz_code` VARCHAR(64) COMMENT '业务编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_score_card_log` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `total` INT COMMENT '总分',
  `score_card_id` VARCHAR(64) COMMENT '评分卡id',
  `exe_log_id` VARCHAR(64) COMMENT '执行日志id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评分卡执行记录';

CREATE TABLE `df_library_monitoring` (
  `id` BIGINT NOT NULL COMMENT '自增ID',
  `library_id` BIGINT NOT NULL COMMENT '指标库id',
  `app_code` VARCHAR(510) NOT NULL COMMENT '系统名称',
  `status` VARCHAR(20) NOT NULL COMMENT '状态:1-有效,0-无效',
  `call_amount` BIGINT COMMENT '调用量',
  `response_time` BIGINT COMMENT '响应时间（毫秒）',
  `failure_rate` INT COMMENT '失败率 (%)',
  `job_id` DECIMAL(20,0) COMMENT '定时任务ID',
  `last_execution_time` DATETIME COMMENT '上次任务执行时间',
  `gap` BIGINT COMMENT '预警周期(分钟)',
  `remark` LONGTEXT COMMENT '备注',
  `create_user` DECIMAL(20,0) COMMENT '创建用户',
  `create_time` DATETIME COMMENT '创建时间',
  `update_user` DECIMAL(20,0) COMMENT '更新用户',
  `update_time` DATETIME COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标库监控配置表';

CREATE TABLE `de_di_dsp_dict` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '名称',
  `dest_code` VARCHAR(64) COMMENT '映射编号',
  `f_id` VARCHAR(64) COMMENT '所属字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_log_level_config` (
  `id` VARCHAR(128) NOT NULL COMMENT '主键',
  `mark` VARCHAR(128) COMMENT '系统标识',
  `log_name` VARCHAR(128) COMMENT '日志名称',
  `log_class` VARCHAR(256),
  `log_level` SMALLINT COMMENT '日志级别',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日志级别配置';

CREATE TABLE `sys_menu_back` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '编号',
  `parent_id` DECIMAL(20,0) COMMENT '所属上级',
  `name` VARCHAR(40) NOT NULL COMMENT '名称',
  `type` SMALLINT NOT NULL COMMENT '类型(0:目录,1:菜单,2:按钮)',
  `path` VARCHAR(200) COMMENT '路由地址',
  `component` VARCHAR(200) COMMENT '组件路径',
  `perms` VARCHAR(200) COMMENT '权限标识',
  `icon` VARCHAR(200) COMMENT '图标',
  `sort_value` BIGINT COMMENT '排序',
  `status` SMALLINT COMMENT '状态(0:禁止,1:正常)',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）',
  `mark` VARCHAR(64) COMMENT '系统标识',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单表';

CREATE TABLE `lsp_user` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '用户id',
  `username` VARCHAR(40) NOT NULL COMMENT '用户名',
  `password` VARCHAR(64) NOT NULL COMMENT '密码',
  `name` VARCHAR(100) COMMENT '姓名',
  `phone` VARCHAR(22) COMMENT '手机',
  `head_url` VARCHAR(400) COMMENT '头像地址',
  `organ_id` VARCHAR(108) COMMENT '机构id',
  `description` VARCHAR(510) COMMENT '描述',
  `status` SMALLINT COMMENT '状态（1：正常 0：停用）',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `update_time` DATETIME NOT NULL COMMENT '更新时间',
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

CREATE TABLE `df_post` (
  `post_id` DECIMAL(38,0) NOT NULL,
  `post_code` VARCHAR(256) NOT NULL,
  `post_name` VARCHAR(200) NOT NULL,
  `post_sort` BIGINT NOT NULL,
  `status` CHAR(4) NOT NULL,
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_oper_log` (
  `oper_id` DECIMAL(38,0) NOT NULL,
  `title` VARCHAR(200),
  `business_type` BIGINT,
  `method` VARCHAR(400),
  `request_method` VARCHAR(40),
  `operator_type` BIGINT,
  `oper_name` VARCHAR(200),
  `dept_name` VARCHAR(200),
  `oper_url` VARCHAR(1020),
  `oper_ip` VARCHAR(200),
  `oper_location` VARCHAR(1020),
  `oper_param` LONGTEXT,
  `json_result` LONGTEXT,
  `status` BIGINT,
  `error_msg` LONGTEXT,
  `oper_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_attachment` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `user_id_` VARCHAR(510),
  `name_` VARCHAR(510),
  `description_` VARCHAR(4000),
  `type_` VARCHAR(510),
  `task_id_` VARCHAR(128),
  `proc_inst_id_` VARCHAR(128),
  `url_` VARCHAR(4000),
  `content_id_` VARCHAR(128),
  `time_` DATETIME(6),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_custom_parameter` (
  `id` BIGINT NOT NULL,
  `source_id` BIGINT NOT NULL,
  `type` VARCHAR(1020) NOT NULL,
  `identifier` VARCHAR(1020) NOT NULL,
  `value` VARCHAR(1020) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_field_250317` (
  `id` BIGINT NOT NULL,
  `interface_id` BIGINT NOT NULL,
  `code` VARCHAR(200) NOT NULL,
  `name` VARCHAR(400) NOT NULL,
  `field_type` VARCHAR(40) NOT NULL,
  `param_type` VARCHAR(8) NOT NULL,
  `default_value` VARCHAR(200),
  `parent_id` BIGINT,
  `required_flag` VARCHAR(8),
  `is_encrypted` VARCHAR(8),
  `length` BIGINT,
  `accuracy` BIGINT,
  `remark` VARCHAR(1020),
  `order_num` BIGINT,
  `default_value_type` VARCHAR(8)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_dsp_log` (
  `id` VARCHAR(64) NOT NULL,
  `tran_no` VARCHAR(64),
  `create_time` DATETIME,
  `start_time` DATETIME,
  `end_time` DATETIME,
  `status` SMALLINT,
  `dispatcher_code` VARCHAR(64),
  `version` INT,
  `input` LONGTEXT,
  `output` LONGTEXT,
  `owner` VARCHAR(64),
  `error_code` VARCHAR(64),
  `error_msg` VARCHAR(512),
  `cnt` SMALLINT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_index_library` (
  `library_id` BIGINT NOT NULL,
  `code` VARCHAR(1020) NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `version` INT,
  `business_id` BIGINT NOT NULL,
  `parent_id` BIGINT NOT NULL,
  `create_time` DATETIME(6),
  `create_user` VARCHAR(128),
  `status` VARCHAR(8) NOT NULL,
  `organ_ids` VARCHAR(2000),
  `organ_id` VARCHAR(128)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_backtrack_dataset` (
  `dataset_id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `dataset_name` VARCHAR(64) COMMENT '数据集名称',
  `library_id` BIGINT COMMENT '指标库id',
  `library_version` INT COMMENT '指标库版本',
  `create_time` DATETIME COMMENT '创建时间',
  `create_by` VARCHAR(64) COMMENT '创建用户',
  PRIMARY KEY (`dataset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回溯数据集';

CREATE TABLE `de_di_model_svc_def` (
  `code` VARCHAR(64) NOT NULL COMMENT '模型服务编号',
  `name` VARCHAR(100) COMMENT '模型名称',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `status` SMALLINT COMMENT '状态',
  `cate_id` VARCHAR(64) COMMENT '归属分类',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型服务定义';

CREATE TABLE `de_di_rule_pkg` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `biz_code` VARCHAR(64) COMMENT '业务编号',
  `svc_id` VARCHAR(64) COMMENT '决策服务',
  `name` VARCHAR(100) COMMENT '规则包名称',
  `hit_return` SMALLINT COMMENT '是否命中退出',
  `ord` INT,
  `p_id` VARCHAR(64) COMMENT '上级包',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_groovy_template` (
  `template_id` BIGINT NOT NULL COMMENT '模版ID(主键)',
  `code` VARCHAR(510) NOT NULL COMMENT '模板code',
  `name` VARCHAR(510) NOT NULL COMMENT '模板名称',
  `groovy_template` LONGTEXT NOT NULL COMMENT '模版groovy',
  `remark` VARCHAR(1024) COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Groovy模版表';

CREATE TABLE `de_di_dec_elm_tmpl` (
  `code` VARCHAR(64) NOT NULL COMMENT '模板编号',
  `name` VARCHAR(100) COMMENT '模板名称',
  `html` LONGTEXT,
  `script` LONGTEXT,
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_role_menu` (
  `role_id` DECIMAL(38,0) NOT NULL,
  `menu_id` DECIMAL(38,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_rule_pkg_execution` (
  `id` VARCHAR(64) NOT NULL,
  `code` VARCHAR(64) COMMENT '规则包业务编号',
  `svc_id` VARCHAR(64) COMMENT '决策服务编号',
  `is_delete` SMALLINT COMMENT '是否删除',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `create_time` DATETIME COMMENT '创建时间',
  `end_time` DATETIME COMMENT '删除时间',
  `script` LONGTEXT,
  `pkg_id` VARCHAR(64) COMMENT '规则包id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_internal_data_index` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '索引ID',
  `table_name` VARCHAR(128) NOT NULL COMMENT '表名',
  `index_name` VARCHAR(128) NOT NULL COMMENT '索引名',
  `columns` VARCHAR(128) NOT NULL COMMENT '列名',
  `type` VARCHAR(510) NOT NULL COMMENT '索引类型',
  `method` VARCHAR(510) NOT NULL COMMENT '索引方法',
  `comment` VARCHAR(512) COMMENT '索引注释'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='存储索引信息的表';

CREATE TABLE `df_field_grant` (
  `field_id` BIGINT NOT NULL,
  `dept_id` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_groovy_template_param` (
  `param_id` BIGINT NOT NULL COMMENT '参数ID(主键)',
  `template_id` BIGINT NOT NULL COMMENT '模版id',
  `code` VARCHAR(510) NOT NULL COMMENT '参数code',
  `name` VARCHAR(510) NOT NULL COMMENT '参数名称',
  `default_value` VARCHAR(510) COMMENT '默认值',
  `required` VARCHAR(4) NOT NULL COMMENT '必填(Y/N)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Groovy模版参数表';

CREATE TABLE `act_hi_procinst` (
  `id_` VARCHAR(128) NOT NULL,
  `proc_inst_id_` VARCHAR(128) NOT NULL,
  `business_key_` VARCHAR(510),
  `proc_def_id_` VARCHAR(128) NOT NULL,
  `start_time_` DATETIME(6) NOT NULL,
  `end_time_` DATETIME(6),
  `duration_` DECIMAL(19,0),
  `start_user_id_` VARCHAR(510),
  `start_act_id_` VARCHAR(510),
  `end_act_id_` VARCHAR(510),
  `super_process_instance_id_` VARCHAR(128),
  `delete_reason_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  `name_` VARCHAR(510),
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `de_di_experiment` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `name` VARCHAR(256) COMMENT '实验名称',
  `svc_code` VARCHAR(64) COMMENT '服务编号',
  `status` SMALLINT COMMENT '状态',
  `create_user` VARCHAR(128) COMMENT '创建人',
  `create_time` DATETIME NOT NULL COMMENT '创建时间',
  `org_no` VARCHAR(64) COMMENT '机构号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='策略实验';

CREATE TABLE `de_di_dict` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `code` VARCHAR(64) COMMENT '编号',
  `name` VARCHAR(100) COMMENT '名称',
  `dest_code` VARCHAR(64) COMMENT '映射编号',
  `f_id` VARCHAR(64) COMMENT '所属字段',
  `cascade_code` VARCHAR(64) COMMENT '级联code',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_ru_deadletter_job` (
  `id_` VARCHAR(128) NOT NULL,
  `rev_` INT,
  `type_` VARCHAR(510) NOT NULL,
  `exclusive_` TINYINT,
  `execution_id_` VARCHAR(128),
  `process_instance_id_` VARCHAR(128),
  `proc_def_id_` VARCHAR(128),
  `exception_stack_id_` VARCHAR(128),
  `exception_msg_` VARCHAR(4000),
  `duedate_` DATETIME(6),
  `repeat_` VARCHAR(510),
  `handler_type_` VARCHAR(510),
  `handler_cfg_` VARCHAR(4000),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `act_ru_deadletter_job` ADD CONSTRAINT `act_fk_djob_exception` FOREIGN KEY (`exception_stack_id_`) REFERENCES `act_ge_bytearray`(`id_`);

ALTER TABLE `act_ru_deadletter_job` ADD CONSTRAINT `act_fk_djob_execution` FOREIGN KEY (`execution_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_deadletter_job` ADD CONSTRAINT `act_fk_djob_process_instance` FOREIGN KEY (`process_instance_id_`) REFERENCES `act_ru_execution`(`id_`);

ALTER TABLE `act_ru_deadletter_job` ADD CONSTRAINT `act_fk_djob_proc_def` FOREIGN KEY (`proc_def_id_`) REFERENCES `act_re_procdef`(`id_`);

CREATE TABLE `sys_menu_ref` (
  `id` DECIMAL(20,0) NOT NULL,
  `url_perm` VARCHAR(128),
  `url` VARCHAR(384),
  `status` SMALLINT,
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME NOT NULL,
  `is_deleted` SMALLINT,
  `mark` VARCHAR(192)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_backtrack_data` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `dataset_id` DECIMAL(20,0) COMMENT '回溯数据集id',
  `tran_no` VARCHAR(128) COMMENT '数据服务日志对应的tran_no',
  `create_time` DATETIME COMMENT '创建时间',
  `create_by` VARCHAR(64) COMMENT '创建用户',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回溯数据集的具体测试数据表';

CREATE TABLE `df_variable_monitoring_log` (
  `log_id` BIGINT NOT NULL COMMENT '日志记录唯一标识，自增主键',
  `monitor_id` BIGINT NOT NULL COMMENT '预警ID',
  `type` VARCHAR(20) NOT NULL COMMENT '0-指标预警日志,1-指标库预警日志',
  `variable_name` VARCHAR(200) NOT NULL COMMENT '被监控的变量名称',
  `gap` BIGINT NOT NULL COMMENT '监控频率（分钟）',
  `sample_size` BIGINT NOT NULL COMMENT '样本数量',
  `missing_rate` INT COMMENT '缺失率（0~1之间的小数）',
  `special_value_rate` INT COMMENT '特殊值占比（0~1之间的小数）',
  `psi_value` INT COMMENT 'PSI 指标值（Population Stability Index）',
  `iv_value` INT COMMENT 'IV 指标值（Information Value）',
  `call_amount` BIGINT COMMENT '调用量',
  `failure_rate` INT COMMENT '失败率',
  `response_time` BIGINT COMMENT '响应时间(毫秒)',
  `created_at` DATETIME COMMENT '日志记录的创建时间',
  `app_code` VARCHAR(510) COMMENT '调用系统名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='变量监控日志表，记录监控指标及预警信息';

CREATE TABLE `de_di_dsp` (
  `code` VARCHAR(64) NOT NULL COMMENT '调度服务编号',
  `name` VARCHAR(100) COMMENT '调度服务名称',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `status` SMALLINT COMMENT '状态',
  `cate_id` VARCHAR(64) COMMENT '归属分类',
  `create_time` DATETIME COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `act_hi_taskinst` (
  `id_` VARCHAR(128) NOT NULL,
  `proc_def_id_` VARCHAR(128),
  `task_def_key_` VARCHAR(510),
  `proc_inst_id_` VARCHAR(128),
  `execution_id_` VARCHAR(128),
  `parent_task_id_` VARCHAR(128),
  `name_` VARCHAR(510),
  `description_` VARCHAR(4000),
  `owner_` VARCHAR(510),
  `assignee_` VARCHAR(510),
  `start_time_` DATETIME(6) NOT NULL,
  `claim_time_` DATETIME(6),
  `end_time_` DATETIME(6),
  `duration_` DECIMAL(19,0),
  `delete_reason_` VARCHAR(4000),
  `priority_` INT,
  `due_date_` DATETIME(6),
  `form_key_` VARCHAR(510),
  `category_` VARCHAR(510),
  `tenant_id_` VARCHAR(510) DEFAULT '',
  PRIMARY KEY (`id_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_role` (
  `role_id` DECIMAL(38,0) NOT NULL,
  `role_name` VARCHAR(120) NOT NULL,
  `role_key` VARCHAR(400) NOT NULL,
  `role_sort` BIGINT NOT NULL,
  `data_scope` CHAR(4),
  `menu_check_strictly` BIGINT,
  `dept_check_strictly` BIGINT,
  `status` CHAR(4) NOT NULL,
  `del_flag` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `gen_table_column` (
  `column_id` DECIMAL(38,0) NOT NULL,
  `table_id` VARCHAR(256),
  `column_name` VARCHAR(800),
  `column_comment` VARCHAR(2000),
  `column_type` VARCHAR(400),
  `java_type` VARCHAR(2000),
  `java_field` VARCHAR(800),
  `is_pk` CHAR(4),
  `is_increment` CHAR(4),
  `is_required` CHAR(4),
  `is_insert` CHAR(4),
  `is_edit` CHAR(4),
  `is_list` CHAR(4),
  `is_query` CHAR(4),
  `query_type` VARCHAR(800),
  `html_type` VARCHAR(800),
  `dict_type` VARCHAR(800),
  `sort` BIGINT,
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lsp_login_log` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '访问ID',
  `username` VARCHAR(100) COMMENT '用户账号',
  `ipaddr` VARCHAR(256) COMMENT '登录IP地址',
  `status` SMALLINT COMMENT '登录状态（0成功 1失败）',
  `msg` VARCHAR(510) COMMENT '提示信息',
  `access_time` DATETIME COMMENT '访问时间',
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME,
  `is_deleted` SMALLINT NOT NULL COMMENT '删除标记（0:可用 1:已删除）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统访问记录';

CREATE TABLE `df_dict_type` (
  `dict_id` DECIMAL(38,0) NOT NULL COMMENT '字典主键',
  `dict_name` VARCHAR(400) COMMENT '字典名称',
  `dict_type` VARCHAR(400) COMMENT '字典类型',
  `status` CHAR(4) COMMENT '状态（0正常 1停用）',
  `create_by` VARCHAR(256) COMMENT '创建者',
  `create_time` DATETIME(6) COMMENT '创建时间',
  `update_by` VARCHAR(256) COMMENT '更新者',
  `update_time` DATETIME(6) COMMENT '更新时间',
  `remark` VARCHAR(2000) COMMENT '备注',
  PRIMARY KEY (`dict_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典类型表';

CREATE TABLE `de_di_decision_svc_execution` (
  `id` VARCHAR(64) NOT NULL,
  `svc_def_code` VARCHAR(64) COMMENT '决策服务定义',
  `version` INT,
  `is_delete` SMALLINT COMMENT '是否删除',
  `org_no` VARCHAR(32) COMMENT '机构号',
  `create_time` DATETIME COMMENT '创建时间',
  `end_time` DATETIME COMMENT '删除时间',
  `shunts` BIGINT COMMENT '分流比例',
  `script` LONGTEXT COMMENT '服务脚本',
  `svc_id` VARCHAR(64),
  `index_lib_id` VARCHAR(64),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_backtrack_log` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键id',
  `tran_no` VARCHAR(64) NOT NULL COMMENT '流水号',
  `task_id` DECIMAL(20,0) NOT NULL COMMENT '回溯任务id',
  `status` CHAR(2) NOT NULL COMMENT '状态：0-处理中，1-成功，2-失败',
  `params` LONGTEXT COMMENT '查询的指标集合',
  `resp_code` VARCHAR(20) COMMENT '返回的code',
  `library_version` INT COMMENT '对应指标库版本',
  `result` LONGTEXT COMMENT '结果',
  `req_time` DATETIME COMMENT '请求时间',
  `resp_time` DATETIME COMMENT '响应时间',
  `create_time` DATETIME COMMENT '创建时间',
  `task_log_id` DECIMAL(20,0) COMMENT '任务记录id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回溯日志表';

CREATE TABLE `df_library_auth_info` (
  `id` DECIMAL(38,0) NOT NULL,
  `library_id` DECIMAL(38,0) NOT NULL,
  `organ_id` DECIMAL(38,0) NOT NULL,
  `mount` VARCHAR(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_menu_ref_back` (
  `url_id` DECIMAL(20,0) NOT NULL,
  `parent_id` DECIMAL(20,0),
  `url` VARCHAR(384),
  `status` SMALLINT,
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME NOT NULL,
  `is_deleted` SMALLINT,
  `mark` VARCHAR(192)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_preheat_exe_log` (
  `tran_no` VARCHAR(64) NOT NULL COMMENT '流水号',
  `params` LONGTEXT COMMENT '预热指标',
  `status` CHAR(2) NOT NULL COMMENT '状态：0-处理中，1-成功，2-失败',
  `resp_code` VARCHAR(20) COMMENT '返回的code',
  `resp_msg` VARCHAR(2000) COMMENT '返回的信息',
  `result` LONGTEXT COMMENT '结果',
  `create_time` DATETIME COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预热指标执行日志表';

CREATE TABLE `de_di_post_user_ref` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `post_code` VARCHAR(64) NOT NULL COMMENT '岗位编号',
  `user_code` VARCHAR(128) COMMENT '用户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='岗位用户表';

CREATE TABLE `df_free_marker_template` (
  `id` BIGINT NOT NULL,
  `code` VARCHAR(1020) NOT NULL,
  `name` VARCHAR(1020) NOT NULL,
  `html` LONGTEXT,
  `script` LONGTEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_user_role` (
  `user_id` DECIMAL(38,0) NOT NULL,
  `role_id` DECIMAL(38,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_data_source_web_info` (
  `id` BIGINT NOT NULL,
  `source_id` BIGINT NOT NULL,
  `login_required` VARCHAR(40),
  `user_auth_code` VARCHAR(128),
  `user_auth_value` VARCHAR(1020),
  `user_auth_field` BIGINT,
  `expire_time` BIGINT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `df_field_monitoring_range` (
  `id` BIGINT NOT NULL COMMENT '主键-自增',
  `limit_id` BIGINT COMMENT '限制表id',
  `min` INT COMMENT '最小值',
  `max` INT COMMENT '最大值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标限制区间表';

CREATE TABLE `df_notice` (
  `notice_id` BIGINT NOT NULL,
  `notice_title` VARCHAR(200) NOT NULL,
  `notice_type` CHAR(4) NOT NULL,
  `notice_content` LONGTEXT,
  `status` CHAR(4),
  `create_by` VARCHAR(256),
  `create_time` DATETIME(6),
  `update_by` VARCHAR(256),
  `update_time` DATETIME(6),
  `remark` VARCHAR(1020)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

