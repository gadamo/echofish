SET NAMES utf8 COLLATE 'utf8_unicode_ci';
SET FOREIGN_KEY_CHECKS=0;
SET time_zone = "+00:00";

ALTER TABLE `host` CHANGE `ip` `ip` varbinary(16) default 0;
ALTER TABLE `whitelist` CHANGE `host` `host` VARCHAR(40) COLLATE utf8_unicode_ci NOT NULL;
ALTER TABLE `whitelist_mem` CHANGE `host` `host` VARCHAR(40) COLLATE utf8_unicode_ci NOT NULL;
ALTER TABLE `abuser_incident` CHANGE `ip` `ip` varbinary(16)  NOT NULL;

/* These are not verified to be error free */
UPDATE `abuser_incident` SET `ip`=INET6_ATON(INET_NTOA(`ip`));
UPDATE `host` SET `ip`=INET6_ATON(INET_NTOA(`ip`));
UPDATE `sysconf` SET id='archive_keep_days' WHERE id='archive_delete_days';

INSERT INTO `sysconf` values
('abuser_rotate','no'),
('abuser_keep_incident','yes'),
('abuser_keep_days',7)
ON DUPLICATE KEY UPDATE `val`=VALUES(`val`);

DELETE FROM `archive` WHERE `host` NOT IN (SELECT id FROM `host`);
DELETE FROM `syslog` WHERE `host` NOT IN (SELECT id FROM `host`);
SET FOREIGN_KEY_CHECKS=1;
