
SET @old_max_allowed_packet := @@max_allowed_packet;

SET @@global.max_allowed_packet := @old_max_allowed_packet;


# CREATE DATABASE `cacti`;
#
# USE `cacti`
CREATE TABLE IF NOT EXISTS `weathermap_maps` (
    `id` int(11) NOT NULL auto_increment
,   `sortorder` int(11) NOT NULL DEFAULT 0
,   `group_id` int(11) NOT NULL DEFAULT 1
,   `active` set('on','off') NOT NULL DEFAULT 'on'
,   `configfile` text NOT NULL
,   `imagefile` text NOT NULL
,   `htmlfile` text NOT NULL
,   `titlecache` text NOT NULL
,   `filehash` varchar(40) NOT NULL DEFAULT ''
,   `warncount` int(11) NOT NULL DEFAULT 0
,   `config` text NOT NULL
,   `thumb_width` int(11) NOT NULL DEFAULT 0
,   `thumb_height` int(11) NOT NULL DEFAULT 0
,   `schedule` varchar(32) NOT NULL DEFAULT '*'
,   `archiving` set('on','off') NOT NULL DEFAULT 'off'
,   PRIMARY KEY (
        `id`
    ) USING BTREE
)
ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `weathermap_data` (
    `id` int(11) NOT NULL auto_increment
,   `rrdfile` varchar(255) NOT NULL
,   `data_source_name` varchar(19) NOT NULL
,   `last_time` int(11) NOT NULL
,   `last_value` varchar(255) NOT NULL
,   `last_calc` varchar(255) NOT NULL
,   `sequence` int(11) NOT NULL
,   `local_data_id` int(11) NOT NULL DEFAULT 0
,   PRIMARY KEY (
        `id`
    ) USING BTREE
,   INDEX `rrdfile` (
        `rrdfile`
    ) USING BTREE
,   INDEX `local_data_id` (
        `local_data_id`
    ) USING BTREE
,   INDEX `data_source_name` (
        `data_source_name`
    ) USING BTREE
)
ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `weathermap_auth` (
    `userid` mediumint(9) NOT NULL DEFAULT 0
,   `mapid` int(11) NOT NULL DEFAULT 0
)
ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `weathermap_groups` (
    `id` int(11) NOT NULL auto_increment
,   `name` varchar(128) NOT NULL DEFAULT ''
,   `sortorder` int(11) NOT NULL DEFAULT 0
,   PRIMARY KEY (
        `id`
    ) USING BTREE
)
ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `weathermap_settings` (
    `id` int(11) NOT NULL auto_increment
,   `mapid` int(11) NOT NULL DEFAULT 0
,   `groupid` int(11) NOT NULL DEFAULT 0
,   `optname` varchar(128) NOT NULL DEFAULT ''
,   `optvalue` varchar(128) NOT NULL DEFAULT ''
,   PRIMARY KEY (
        `id`
    ) USING BTREE
)
ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `settings` (
    `name` varchar(50) NOT NULL DEFAULT ''
,   `value` varchar(255) NOT NULL DEFAULT ''
,   PRIMARY KEY (
        `name`
    ) USING BTREE
)
ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `user_auth` (
    `id` mediumint(8) unsigned NOT NULL auto_increment
,   `username` varchar(50) NOT NULL DEFAULT '0'
,   `password` varchar(50) NOT NULL DEFAULT '0'
,   `realm` mediumint(8) NOT NULL DEFAULT 0
,   `full_name` varchar(100) DEFAULT '0'
,   `must_change_password` char(2)
,   `show_tree` char(2) DEFAULT 'on'
,   `show_list` char(2) DEFAULT 'on'
,   `show_preview` char(2) NOT NULL DEFAULT 'on'
,   `graph_settings` char(2)
,   `login_opts` tinyint(1) NOT NULL DEFAULT 1
,   `policy_graphs` tinyint(1) unsigned NOT NULL DEFAULT 1
,   `policy_trees` tinyint(1) unsigned NOT NULL DEFAULT 1
,   `policy_hosts` tinyint(1) unsigned NOT NULL DEFAULT 1
,   `policy_graph_templates` tinyint(1) unsigned NOT NULL DEFAULT 1
,   `enabled` char(2) NOT NULL DEFAULT 'on'
,   PRIMARY KEY (
        `id`
    ) USING BTREE
,   INDEX `username` (
        `username`
    ) USING BTREE
,   INDEX `realm` (
        `realm`
    ) USING BTREE
,   INDEX `enabled` (
        `enabled`
    ) USING BTREE
)
ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `user_auth_perms` (
    `user_id` mediumint(8) unsigned NOT NULL DEFAULT 0
,   `item_id` mediumint(8) unsigned NOT NULL DEFAULT 0
,   `type` tinyint(2) unsigned NOT NULL DEFAULT 0
,   PRIMARY KEY (
        `user_id`
    ,   `item_id`
    ,   `type`
    ) USING BTREE
,   INDEX `user_id` (
        `user_id`
    ,   `type`
    ) USING BTREE
)
ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `user_auth_realm` (
    `realm_id` mediumint(8) unsigned NOT NULL DEFAULT 0
,   `user_id` mediumint(8) unsigned NOT NULL DEFAULT 0
,   PRIMARY KEY (
        `realm_id`
    ,   `user_id`
    ) USING BTREE
,   INDEX `user_id` (
        `user_id`
    ) USING BTREE
)
ENGINE = MyISAM;

START TRANSACTION;

INSERT INTO `weathermap_maps` (`id`, `sortorder`, `group_id`, `active`, `configfile`, `imagefile`, `htmlfile`, `titlecache`, `filehash`, `warncount`, `config`, `thumb_width`, `thumb_height`, `schedule`, `archiving`) VALUES
(1, 5, 1, 'on', 'simple.conf', '', '', 'test', 'b4964c0d7f4f300f1675', 0, '', 0, 0, '*', 'off'),
(2, 6, 1, 'on', '097-simple.conf', '', '', '0.97 DS changes', '505796aabcca62711707', 0, '', 0, 0, '*', 'off'),
(5, 3, 1, 'on', '097-test.conf', '', '', '0.96 Test Map {map:titleextra}', '87c16c1c3430a9ccfd1a', 0, '', 0, 0, '*', 'off'),
(4, 4, 1, 'on', 'torture.conf', '', '', '(no title)', 'abec33d43367435356aa', 0, '', 0, 0, '*', 'off'),
(6, 2, 1, 'on', '094-test.conf', '', '', 'Testing THold DS', 'a7914efbc053964d7711', 0, '', 0, 0, '*', 'off'),
(7, 1, 1, 'on', 'switch-status-2.conf', '', '', 'same map as switch-status.conf, but with every port scaled', '99639caa5ed4ab8ad7a2', 0, '', 0, 0, '*', 'off');
COMMIT;

START TRANSACTION;

INSERT INTO `weathermap_auth` (`userid`, `mapid`) VALUES
(1, 1),
(1, 2),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(2, 7);
COMMIT;

START TRANSACTION;

INSERT INTO `weathermap_groups` (`id`, `name`, `sortorder`) VALUES
(1, 'Weathermaps', 2),
(2, 'g1', 1),
(3, 'g2', 3);
COMMIT;

START TRANSACTION;

INSERT INTO `weathermap_settings` (`id`, `mapid`, `groupid`, `optname`, `optvalue`) VALUES
(5, 0, 0, 'rrd_use_poller_output', '1');
COMMIT;

START TRANSACTION;

INSERT INTO `settings` (`name`, `value`) VALUES
('path_rrdtool', '/usr/local/bin/rrdtool'),
('path_php_binary', '/usr/bin/php'),
('path_snmpwalk', '/usr/bin/snmpwalk'),
('path_snmpget', '/usr/bin/snmpget'),
('path_snmpbulkwalk', '/usr/bin/snmpbulkwalk'),
('path_snmpgetnext', '/usr/bin/snmpgetnext'),
('path_cactilog', '/Applications/XAMPP/xamppfiles/htdocs/cacti/log/cacti.log'),
('snmp_version', 'net-snmp'),
('rrdtool_version', 'rrd-1.2.x'),
('weathermap_pagestyle', '0'),
('weathermap_cycle_refresh', '0'),
('weathermap_render_period', '0'),
('weathermap_quiet_logging', '0'),
('weathermap_render_counter', '0'),
('weathermap_output_format', 'png'),
('weathermap_thumbsize', '250'),
('weathermap_map_selector', '1'),
('weathermap_all_tab', '0'),
('weathermap_db_version', '0.98'),
('weathermap_version', ''),
('boost_rrd_update_enable', 'on'),
('boost_rrd_update_system_enable', ''),
('boost_rrd_update_interval', '60'),
('boost_rrd_update_max_records', '1000000'),
('boost_rrd_update_max_records_per_select', '50000'),
('boost_rrd_update_string_length', '2000'),
('boost_poller_mem_limit', '1024'),
('boost_rrd_update_max_runtime', '1200'),
('boost_redirect', ''),
('boost_server_enable', ''),
('boost_server_effective_user', 'root'),
('boost_server_multiprocess', '1'),
('boost_path_rrdupdate', ''),
('boost_server_hostname', 'localhost'),
('boost_server_listen_port', '9050'),
('boost_server_timeout', '2'),
('boost_server_clients', '127.0.0.1'),
('boost_png_cache_enable', ''),
('boost_png_cache_directory', ''),
('path_boost_log', '');
COMMIT;

START TRANSACTION;

INSERT INTO `user_auth` (`id`, `username`, `password`, `realm`, `full_name`, `must_change_password`, `show_tree`, `show_list`, `show_preview`, `graph_settings`, `login_opts`, `policy_graphs`, `policy_trees`, `policy_hosts`, `policy_graph_templates`, `enabled`) VALUES
(1, 'admin', 'f633c61683da283f0cbbac923eca8ea3', 0, 'Administrator', '', 'on', 'on', 'on', 'on', 1, 1, 1, 1, 1, 'on'),
(3, 'guest', '43e9a4ab75570f5b', 0, 'Guest Account', 'on', 'on', 'on', 'on', 'on', 3, 1, 1, 1, 1, '');
COMMIT;

START TRANSACTION;

INSERT INTO `user_auth_realm` (`realm_id`, `user_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(7, 1),
(7, 3),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 1),
(17, 1),
(101, 1),
(104, 1),
(105, 1),
(106, 1);
COMMIT;



SET @@global.max_allowed_packet := @old_max_allowed_packet;
