TRUNCATE TABLE page;
TRUNCATE TABLE text;
TRUNCATE TABLE revision;
ALTER TABLE revision modify rev_comment blob;
TRUNCATE TABLE redirect;

DROP INDEX IF EXISTS `name_title` on page;
DROP INDEX IF EXISTS `page_random` on page;
DROP INDEX IF EXISTS `page_len` on page;
DROP INDEX IF EXISTS `page_redirect_namespace_len` on page;

alter table revision CHANGE rev_id rev_id INTEGER UNSIGNED;
alter table text CHANGE old_id old_id INTEGER UNSIGNED;
alter table page CHANGE page_id page_id INTEGER UNSIGNED;
