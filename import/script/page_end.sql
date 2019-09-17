ALTER TABLE `page` ADD UNIQUE `name_title` (`page_namespace`,`page_title`);
CREATE INDEX `page_random` ON `page` (`page_random`);
CREATE INDEX `page_len` ON `page` (`page_len`);
CREATE INDEX `page_redirect_namespace_len` ON `page` (`page_is_redirect`,`page_namespace`,`page_len`);

alter table revision CHANGE rev_id rev_id INTEGER UNSIGNED AUTO_INCREMENT;
alter table text CHANGE old_id old_id INTEGER UNSIGNED AUTO_INCREMENT;
alter table page CHANGE page_id page_id INTEGER UNSIGNED AUTO_INCREMENT;
