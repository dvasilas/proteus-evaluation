CREATE DATABASE IF NOT EXISTS proteus_lobsters_db;

USE proteus_lobsters_db;

CREATE TABLE IF NOT EXISTS`users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `stories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `title` varchar(150) NOT NULL DEFAULT '',
  `description` mediumtext NOT NULL,
  `short_id` varchar(6) NOT NULL DEFAULT '',
  `ts` datetime(6) DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  PRIMARY KEY (`id`),
  CONSTRAINT `stories_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `comments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `story_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `comment` mediumtext NOT NULL,
  `ts` datetime(6) DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  PRIMARY KEY (`id`),
  CONSTRAINT `comments_story_id_fk` FOREIGN KEY (`story_id`) REFERENCES `stories` (`id`),
  CONSTRAINT `comments_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `votes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `story_id` bigint unsigned NOT NULL,
  `comment_id` bigint unsigned DEFAULT NULL,
  `vote` tinyint NOT NULL,
  `ts` datetime(6) DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  PRIMARY KEY (`id`),
  CONSTRAINT `votes_comment_id_fk` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `votes_story_id_fk` FOREIGN KEY (`story_id`) REFERENCES `stories` (`id`),
  CONSTRAINT `votes_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB;

DROP FUNCTION IF EXISTS MySQLNotification;
CREATE FUNCTION MySQLNotification RETURNS INTEGER SONAME 'lib_sys_exec.so';

DELIMITER @@

DROP TRIGGER IF EXISTS `votes_trigger` @@
CREATE TRIGGER `votes_trigger` AFTER INSERT ON `votes`
FOR EACH ROW
BEGIN
  IF NEW.comment_id IS NULL THEN
    SELECT MySQLNotification("votes", New.ts, New.vote, New.story_id) INTO @x;
  ELSE
    SELECT MySQLNotification("votes", New.ts, New.vote, New.story_id, New.comment_id) INTO @x;
  END IF;
END@@

DROP TRIGGER IF EXISTS `stories_trigger` @@
CREATE TRIGGER `stories_trigger` AFTER INSERT ON `stories`
FOR EACH ROW
BEGIN
  SELECT MySQLNotification("stories", New.ts, New.id, New.user_id, New.title, New.description, New.short_id) INTO @x;
END@@

DROP TRIGGER IF EXISTS `comments_trigger` @@
CREATE TRIGGER `comments_trigger` AFTER INSERT ON `comments`
FOR EACH ROW
BEGIN
  SELECT MySQLNotification("comments",  New.ts, New.id, New.user_id, New.story_id, New.comment) INTO @x;
END@@

DELIMITER ;

-- DELIMITER $
-- DROP TRIGGER IF EXISTS `votes_trigger` $
-- CREATE TRIGGER `votes_trigger`
-- AFTER INSERT ON `votes`
-- FOR EACH ROW
-- BEGIN
--   DECLARE cmd CHAR(255);
--   DECLARE result int(10);
--       IF NEW.comment_id IS NULL THEN
--           SET cmd = CONCAT('python /opt/proteus-lobsters/trigger.py ', 'votes ', New.id, ' "', New.ts, '" story_id:', New.story_id, ' vote:', New.vote);
--           SET result = sys_exec(cmd);
--       ELSE
--           SET cmd = CONCAT('python /opt/proteus-lobsters/trigger.py ', 'votes ', New.id, ' "', New.ts, '" story_id:', New.story_id, ' comment_id:', New.comment_id, ' vote:', New.vote);
--           SET result = sys_exec(cmd);
--       END IF;
-- END;
-- DROP TRIGGER IF EXISTS `stories_trigger` $
-- CREATE TRIGGER `stories_trigger`
-- AFTER INSERT ON `stories`
-- FOR EACH ROW
-- BEGIN
--   DECLARE cmd CHAR(255);
--   DECLARE result int(10);
--       SET cmd = CONCAT('python /opt/proteus-lobsters/trigger.py ', 'stories ', New.id, ' "', New.ts, '" id:', New.id, ' user_id:', New.user_id, ' title:"', New.title, '" description:"', New.description, '" short_id:', New.short_id);
--       SET result = sys_exec(cmd);
-- END;
-- DROP TRIGGER IF EXISTS `comments_trigger` $
-- CREATE TRIGGER `comments_trigger`
-- AFTER INSERT ON `comments`
-- FOR EACH ROW
-- BEGIN
--   DECLARE cmd CHAR(255);
--   DECLARE result int(10);
--       SET cmd = CONCAT('python /opt/proteus-lobsters/trigger.py ', 'comments ', New.id, ' "', New.ts, '" id:', New.id, ' user_id:', New.user_id, ' story_id:', New.story_id, ' comment:"', New.comment, '"');
--       SET result = sys_exec(cmd);
-- END;
-- $
-- DELIMITER ;