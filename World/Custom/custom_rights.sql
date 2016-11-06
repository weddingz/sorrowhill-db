/* Set custom rights for PTR realm */

UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'additem';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'additemset';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'cooldown';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` LIKE 'gobject%';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'honor add';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'learn';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'learn all_myclass';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'learn all_myspells';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'learn all_mytalents';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'learn all_recipes';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'learn all_default';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'learn all_crafts';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'lookup item';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'lookup itemset';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'lookup spell';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'lookup skill';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'lookup creature';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'lookup faction';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'lookup object';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'lookup quest';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'lookup taxinode';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'lookup tele';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'maxskill';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'modify rep';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` LIKE 'npc%';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'repairitems';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'reset spells';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'reset talents';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'revive';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'setskill';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` LIKE 'tele%';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'unaura';
UPDATE `command` SET `security` = '1' WHERE `command`.`name` = 'unlearn';

