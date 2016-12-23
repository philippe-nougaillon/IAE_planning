PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
INSERT INTO "schema_migrations" VALUES('20161208092212');
INSERT INTO "schema_migrations" VALUES('20161208092434');
INSERT INTO "schema_migrations" VALUES('20161208093307');
INSERT INTO "schema_migrations" VALUES('20161208093838');
INSERT INTO "schema_migrations" VALUES('20161208094533');
INSERT INTO "schema_migrations" VALUES('20161209120007');
INSERT INTO "schema_migrations" VALUES('20161215084505');
INSERT INTO "schema_migrations" VALUES('20161215113834');
INSERT INTO "schema_migrations" VALUES('20161215114043');
INSERT INTO "schema_migrations" VALUES('20161215132348');
INSERT INTO "schema_migrations" VALUES('20161215133923');
INSERT INTO "schema_migrations" VALUES('20161215135814');
INSERT INTO "schema_migrations" VALUES('20161216134200');
INSERT INTO "schema_migrations" VALUES('20161219092702');
INSERT INTO "schema_migrations" VALUES('20161219095432');
INSERT INTO "schema_migrations" VALUES('20161220131859');
CREATE TABLE "intervenants" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "nom" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "prenom" varchar, "email" varchar);
INSERT INTO "intervenants" VALUES(1,'LAPORTE','2016-12-08 09:42:44.050824','2016-12-08 09:48:53.364564','Marie-Eve',NULL);
INSERT INTO "intervenants" VALUES(2,'ZINAÏ','2016-12-08 09:43:00.205639','2016-12-08 09:50:25.177740','Karim',NULL);
INSERT INTO "intervenants" VALUES(3,'SEPULVEDA','2016-12-08 09:43:13.008201','2016-12-08 09:50:37.788695','José-Miguel',NULL);
INSERT INTO "intervenants" VALUES(4,'MICHEL ','2016-12-08 09:43:45.168817','2016-12-08 09:50:49.204779','Géraldine',NULL);
INSERT INTO "intervenants" VALUES(5,'AURENGO','2016-12-08 09:44:01.063367','2016-12-16 13:44:59.147579','André','andre.aurengo@gmail.com');
INSERT INTO "intervenants" VALUES(6,'ZEITOUN','2016-12-08 09:44:15.883659','2016-12-08 09:51:13.406656','Valérie',NULL);
INSERT INTO "intervenants" VALUES(7,'TRAN','2016-12-08 09:44:43.509596','2016-12-08 09:51:25.294688','Béatrice',NULL);
INSERT INTO "intervenants" VALUES(8,'SABRI','2016-12-08 15:03:29.673587','2016-12-08 15:03:29.673587','Ouidade',NULL);
INSERT INTO "intervenants" VALUES(9,'BREON-NORMAND','2016-12-08 15:08:06.096345','2016-12-08 15:08:06.096345','Valérie',NULL);
INSERT INTO "intervenants" VALUES(10,'CUNNIET','2016-12-09 13:53:11.628098','2016-12-09 13:53:11.628098','Jean-Philippe',NULL);
INSERT INTO "intervenants" VALUES(11,'Eynaud','2016-12-19 10:37:38.807785','2016-12-19 13:13:55.710355','Philippe','ph@univ-paris1.fr');
INSERT INTO "intervenants" VALUES(12,'Raulet-Croset','2016-12-19 10:41:03.033819','2016-12-19 10:41:03.033819','Nathalie','');
INSERT INTO "intervenants" VALUES(13,'Dournaux','2016-12-19 10:41:39.374056','2016-12-19 10:41:39.374056','M.','');
INSERT INTO "intervenants" VALUES(14,'IAE','2016-12-19 11:14:32.627570','2016-12-19 11:14:32.627570','Paris','');
INSERT INTO "intervenants" VALUES(15,'Schmidt','2016-12-19 11:20:06.696064','2016-12-19 11:20:06.696064','G.','');
INSERT INTO "intervenants" VALUES(16,'Laville','2016-12-19 11:20:26.769191','2016-12-19 11:20:26.769191','JL.','');
INSERT INTO "intervenants" VALUES(17,'Fraisse','2016-12-19 15:51:28.784387','2016-12-19 15:51:28.784387','L.','');
INSERT INTO "intervenants" VALUES(18,'Maurel','2016-12-19 15:54:26.771725','2016-12-19 15:54:26.771725','O.','');
INSERT INTO "intervenants" VALUES(19,'Delsol','2016-12-19 16:58:43.528061','2016-12-19 16:58:43.528061','X.','');
INSERT INTO "intervenants" VALUES(20,'Traversaz','2016-12-19 17:38:36.447371','2016-12-19 17:38:36.447371','F.','');
INSERT INTO "intervenants" VALUES(21,'Gilbert','2016-12-19 17:39:06.735998','2016-12-19 17:39:06.735998','P.','');
INSERT INTO "intervenants" VALUES(22,'Blyweert','2016-12-19 17:55:17.862379','2016-12-19 17:55:17.862379','V.','');
INSERT INTO "intervenants" VALUES(23,'Wiedemann-Goiran','2016-12-19 18:00:45.700853','2016-12-19 18:00:45.700853','T.','');
CREATE TABLE "formations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "nom" varchar, "promo" varchar, "diplome" varchar, "domaine" varchar, "apprentissage" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "memo" varchar, "nbr_etudiants" integer);
INSERT INTO "formations" VALUES(1,'MBA Marketing Communication et Santé','2016/2017','MBA','MARKETING COMMUNICATION ET SANTE','f','2016-12-08 09:41:32.395345','2016-12-19 15:34:05.019009','Examen le 12/03/2016',7);
INSERT INTO "formations" VALUES(4,'Master Management des Associations','2017','Master','','f','2016-12-19 10:08:57.482390','2016-12-19 11:21:36.022321','',20);
CREATE TABLE "salles" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "nom" varchar, "places" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
INSERT INTO "salles" VALUES(1,'A1',30,'2016-12-08 10:05:07.001230','2016-12-08 10:05:07.001230');
INSERT INTO "salles" VALUES(2,'A2',30,'2016-12-08 10:05:17.131225','2016-12-08 10:05:17.131225');
INSERT INTO "salles" VALUES(3,'A3',30,'2016-12-08 10:05:26.665591','2016-12-08 10:05:26.665591');
INSERT INTO "salles" VALUES(4,'A4',30,'2016-12-08 10:05:38.113645','2016-12-08 10:05:38.113645');
INSERT INTO "salles" VALUES(5,'A5',30,'2016-12-08 10:06:01.052125','2016-12-08 10:06:01.052125');
INSERT INTO "salles" VALUES(6,'B1',30,'2016-12-08 10:06:10.735476','2016-12-08 10:06:10.735476');
INSERT INTO "salles" VALUES(7,'B2',30,'2016-12-08 10:06:27.171323','2016-12-08 10:06:27.171323');
INSERT INTO "salles" VALUES(8,'B3',30,'2016-12-08 10:06:38.013626','2016-12-08 10:06:38.013626');
INSERT INTO "salles" VALUES(9,'D1',30,'2016-12-08 10:06:50.735214','2016-12-08 10:06:50.735214');
INSERT INTO "salles" VALUES(10,'D2',30,'2016-12-08 10:07:00.333480','2016-12-08 10:07:00.333480');
INSERT INTO "salles" VALUES(11,'D3',30,'2016-12-08 10:07:09.372756','2016-12-08 10:07:09.372756');
CREATE TABLE "cours" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "debut" datetime, "fin" datetime, "formation_id" integer, "intervenant_id" integer, "salle_id" integer, "ue" varchar, "nom" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "etat" integer DEFAULT 0);
INSERT INTO "cours" VALUES(1,'2016-12-08 09:00:00.000000','2016-12-08 12:00:00.000000',1,2,2,'UE6','Business game intégration + brief travail de groupe','2016-12-08 10:57:27.454023','2016-12-16 14:32:40.787568',3);
INSERT INTO "cours" VALUES(2,'2016-12-08 13:30:00.000000','2016-12-08 17:00:00.000000',1,1,10,'','TEST','2016-12-08 11:02:42.014302','2016-12-21 12:23:02.357222',1);
INSERT INTO "cours" VALUES(3,'2016-12-14 09:00:00.000000','2016-12-14 12:00:00.000000',1,1,NULL,'UE6','Stratégie de communication santé: fondamentaux','2016-12-08 13:24:11.406867','2016-12-21 11:41:25.972248',3);
INSERT INTO "cours" VALUES(4,'2016-12-14 13:30:00.000000','2016-12-14 17:30:00.000000',1,1,8,'U6','Stratégie de communication santé: fondamentaux','2016-12-08 13:25:16.536915','2016-12-16 09:25:37.466035',3);
INSERT INTO "cours" VALUES(5,'2016-12-15 09:00:00.000000','2016-12-15 12:00:00.000000',1,4,NULL,'UE4','Marketing stratégique de la santé: fondamentaux','2016-12-08 14:57:56.353557','2016-12-08 14:57:56.353557',0);
INSERT INTO "cours" VALUES(6,'2016-12-15 12:30:00.000000','2016-12-15 18:30:00.000000',1,1,NULL,'UE6','Stratégie de communication santé: fondamentaux','2016-12-08 15:00:53.098910','2016-12-08 15:00:53.098910',0);
INSERT INTO "cours" VALUES(7,'2016-12-16 09:00:00.000000','2016-12-16 12:00:00.000000',1,8,1,'UE5','Marketing, techniques et approches opérationnelles: fondamentaux','2016-12-08 15:07:01.416133','2016-12-16 15:30:16.431836',3);
INSERT INTO "cours" VALUES(8,'2016-12-16 14:00:00.000000','2016-12-16 18:00:00.000000',1,9,NULL,'','Ethique, contexte légal et droit de la santé','2016-12-08 15:08:43.607292','2016-12-08 15:08:43.607292',0);
INSERT INTO "cours" VALUES(9,'2017-01-27 09:00:00.000000','2017-01-27 13:00:00.000000',1,8,NULL,'UE6','Marketing, techniques et approches opérationnelles: fondamentaux','2016-12-09 13:54:44.975340','2016-12-09 14:08:53.290713',0);
INSERT INTO "cours" VALUES(10,'2017-01-27 13:30:00.000000','2017-01-27 16:30:00.000000',1,8,NULL,'UE6','Marketing, techniques et approches opérationnelles: fondamentaux','2016-12-09 13:56:52.914887','2016-12-09 14:08:34.915110',0);
INSERT INTO "cours" VALUES(11,'2017-01-26 09:00:00.000000','2017-01-26 12:00:00.000000',1,10,NULL,'UE6','Stratégie de communication santé: fondamentaux','2016-12-09 13:57:40.030070','2016-12-09 14:05:23.538110',0);
INSERT INTO "cours" VALUES(12,'2017-01-26 13:30:00.000000','2017-01-26 16:30:00.000000',1,8,NULL,'UE6','Stratégie de communication santé: fondamentaux','2016-12-09 13:59:49.870121','2016-12-09 14:06:19.510743',0);
INSERT INTO "cours" VALUES(13,'2017-01-11 09:00:00.000000','2017-01-11 09:45:00.000000',4,11,NULL,'','Réunion de Rentrée','2016-12-19 10:37:57.225942','2016-12-22 11:30:37.071044',2);
INSERT INTO "cours" VALUES(14,'2017-01-11 09:30:00.000000','2017-01-11 12:30:00.000000',4,12,NULL,'UE9','','2016-12-19 10:49:17.598624','2016-12-19 10:50:15.114410',1);
INSERT INTO "cours" VALUES(15,'2017-01-11 14:00:00.000000','2017-01-11 17:00:00.000000',4,12,NULL,'UE9','','2016-12-19 10:49:48.992063','2016-12-21 11:54:17.164364',3);
INSERT INTO "cours" VALUES(16,'2017-01-12 09:00:00.000000','2017-01-12 12:00:00.000000',4,13,NULL,'UE2','','2016-12-19 11:04:27.365466','2016-12-19 11:04:27.365466',1);
INSERT INTO "cours" VALUES(17,'2017-01-12 13:30:00.000000','2017-01-12 16:30:00.000000',4,13,NULL,'UE2','','2016-12-19 11:05:22.252629','2016-12-19 11:05:22.252629',1);
INSERT INTO "cours" VALUES(18,'2017-01-12 16:30:00.000000','2017-01-12 17:30:00.000000',4,13,NULL,'UE9','Fiche de lecture','2016-12-19 11:07:28.153560','2016-12-19 11:07:28.153560',1);
INSERT INTO "cours" VALUES(19,'2017-01-12 18:30:00.000000','2017-01-12 20:00:00.000000',4,11,NULL,'','Conférence Chaire MAI','2016-12-19 11:09:09.110791','2016-12-19 11:09:09.110791',1);
INSERT INTO "cours" VALUES(20,'2017-01-13 09:00:00.000000','2017-01-13 10:30:00.000000',4,13,NULL,'UE2','','2016-12-19 11:12:09.186621','2016-12-19 11:12:38.919098',1);
INSERT INTO "cours" VALUES(21,'2017-01-13 12:00:00.000000','2017-01-13 13:00:00.000000',4,14,NULL,'','Apéritif inter-promotions','2016-12-19 11:15:42.724114','2016-12-19 11:15:42.724114',1);
INSERT INTO "cours" VALUES(22,'2017-01-13 13:30:00.000000','2017-01-13 16:30:00.000000',4,13,NULL,'UE2','','2016-12-19 11:16:13.438609','2016-12-19 11:16:13.438609',1);
INSERT INTO "cours" VALUES(23,'2017-02-15 09:00:00.000000','2017-02-15 12:00:00.000000',4,11,NULL,'UE9','','2016-12-19 11:24:05.271627','2016-12-19 11:24:05.271627',1);
INSERT INTO "cours" VALUES(24,'2017-02-15 13:30:00.000000','2017-02-15 16:30:00.000000',4,11,NULL,'UE9','','2016-12-19 11:26:06.522435','2016-12-19 11:26:06.522435',1);
INSERT INTO "cours" VALUES(25,'2017-02-16 09:00:00.000000','2017-02-16 12:00:00.000000',4,15,NULL,'UE3','','2016-12-19 11:28:40.885039','2016-12-19 11:28:40.885039',1);
INSERT INTO "cours" VALUES(26,'2017-02-16 13:30:00.000000','2017-02-16 16:30:00.000000',4,12,NULL,'UE9','Présentation du Projet transversal et méthodologie','2016-12-19 11:30:21.045036','2016-12-19 11:30:21.045036',1);
INSERT INTO "cours" VALUES(27,'2017-02-17 09:00:00.000000','2017-02-17 12:00:00.000000',4,16,NULL,'UE1','','2016-12-19 11:31:31.011212','2016-12-19 11:31:31.011212',1);
INSERT INTO "cours" VALUES(28,'2017-02-17 13:00:00.000000','2017-02-17 16:00:00.000000',4,16,NULL,'UE1','','2016-12-19 11:31:44.077397','2016-12-19 11:31:44.077397',1);
INSERT INTO "cours" VALUES(29,'2017-03-15 09:00:00.000000','2017-03-15 12:00:00.000000',4,15,NULL,'UE3','','2016-12-19 15:49:52.832067','2016-12-19 16:07:00.091916',1);
INSERT INTO "cours" VALUES(30,'2017-03-15 13:30:00.000000','2017-03-15 16:30:00.000000',4,15,NULL,'UE3','','2016-12-19 15:50:20.216912','2016-12-19 16:07:15.963627',1);
INSERT INTO "cours" VALUES(31,'2017-03-16 09:00:00.000000','2017-03-16 12:00:00.000000',4,17,NULL,'UE1','','2016-12-19 15:51:45.611668','2016-12-19 16:09:49.312537',1);
INSERT INTO "cours" VALUES(32,'2017-03-16 13:30:00.000000','2017-03-16 16:30:00.000000',4,17,NULL,'UE1','','2016-12-19 15:53:53.039015','2016-12-19 16:10:04.263368',1);
INSERT INTO "cours" VALUES(33,'2017-03-17 09:00:00.000000','2017-03-17 12:00:00.000000',4,18,NULL,'UE9','','2016-12-19 15:56:10.725933','2016-12-19 16:10:19.466129',1);
INSERT INTO "cours" VALUES(34,'2017-03-17 13:30:00.000000','2017-03-17 16:30:00.000000',4,18,NULL,'UE9','','2016-12-19 15:57:03.040127','2016-12-19 16:10:36.912448',1);
INSERT INTO "cours" VALUES(35,'2017-05-17 09:00:00.000000','2017-05-17 12:00:00.000000',4,21,NULL,'UE3','','2016-12-19 17:40:36.815345','2016-12-19 17:40:36.815345',1);
INSERT INTO "cours" VALUES(36,'2017-05-17 13:30:00.000000','2017-05-17 16:30:00.000000',4,21,NULL,'UE3','','2016-12-19 17:40:58.152217','2016-12-19 17:40:58.152217',1);
INSERT INTO "cours" VALUES(37,'2017-05-17 16:45:00.000000','2017-05-17 17:45:00.000000',4,12,NULL,'UE9','Méthodologie Mémoire','2016-12-19 17:41:45.430940','2016-12-19 17:41:45.430940',1);
INSERT INTO "cours" VALUES(38,'2017-05-18 09:00:00.000000','2017-05-18 12:00:00.000000',4,19,NULL,'UE2','','2016-12-19 17:42:28.124964','2016-12-19 17:42:28.124964',1);
INSERT INTO "cours" VALUES(39,'2017-05-18 13:30:00.000000','2017-05-18 16:30:00.000000',4,19,NULL,'UE2','','2016-12-19 17:42:57.557003','2016-12-19 17:42:57.557003',1);
INSERT INTO "cours" VALUES(40,'2017-05-19 09:00:00.000000','2017-05-19 12:00:00.000000',4,20,NULL,'UE1','','2016-12-19 17:44:05.351977','2016-12-19 17:44:05.351977',1);
INSERT INTO "cours" VALUES(41,'2017-05-19 13:30:00.000000','2017-05-19 16:30:00.000000',4,20,NULL,'UE1','','2016-12-19 17:44:23.633426','2016-12-19 17:44:23.633426',1);
INSERT INTO "cours" VALUES(42,'2017-06-14 09:00:00.000000','2017-06-14 12:00:00.000000',4,14,NULL,'??','???? ','2016-12-19 17:48:30.493224','2016-12-19 17:48:30.493224',1);
INSERT INTO "cours" VALUES(43,'2017-06-14 13:30:00.000000','2017-06-14 15:30:00.000000',4,12,NULL,'UE9','Méthodologies','2016-12-19 17:49:10.500338','2016-12-19 17:49:10.500338',1);
INSERT INTO "cours" VALUES(44,'2017-06-15 09:00:00.000000','2017-06-15 12:00:00.000000',4,20,NULL,'UE1','','2016-12-19 17:50:17.163050','2016-12-19 17:50:17.163050',1);
INSERT INTO "cours" VALUES(45,'2017-06-15 13:30:00.000000','2017-06-15 16:30:00.000000',4,20,NULL,'UE1','','2016-12-19 17:51:02.830131','2016-12-19 17:51:02.830131',1);
INSERT INTO "cours" VALUES(46,'2017-06-16 09:00:00.000000','2017-06-16 12:00:00.000000',4,20,NULL,'UE9','Secteur Associatif - ESS','2016-12-19 17:51:46.993004','2016-12-19 17:51:46.993004',1);
INSERT INTO "cours" VALUES(47,'2017-06-16 13:30:00.000000','2017-06-16 16:30:00.000000',4,23,NULL,'UE9','Présentation Fiche de Lecture','2016-12-19 17:52:39.253038','2016-12-19 18:01:17.892249',1);
INSERT INTO "cours" VALUES(48,'2017-07-05 09:00:00.000000','2017-07-05 12:00:00.000000',4,18,NULL,'UE3','','2016-12-19 17:54:54.785661','2016-12-19 17:54:54.785661',1);
INSERT INTO "cours" VALUES(49,'2017-07-05 13:30:00.000000','2017-07-05 16:30:00.000000',4,22,NULL,'UE3','','2016-12-19 17:55:47.994883','2016-12-19 17:55:47.994883',1);
INSERT INTO "cours" VALUES(50,'2017-07-06 09:00:00.000000','2017-07-06 12:00:00.000000',4,20,NULL,'UE9','Projet Transversal - 1ère Partie','2016-12-19 17:56:38.060936','2016-12-19 17:56:38.060936',1);
INSERT INTO "cours" VALUES(51,'2017-07-06 13:30:00.000000','2017-07-06 16:30:00.000000',4,14,NULL,'??','','2016-12-19 17:57:20.376678','2016-12-19 17:57:20.376678',1);
INSERT INTO "cours" VALUES(52,'2017-07-07 09:00:00.000000','2017-07-07 12:00:00.000000',4,22,NULL,'UE3','','2016-12-19 17:58:02.701600','2016-12-19 17:59:40.668489',1);
INSERT INTO "cours" VALUES(53,'2017-07-07 13:30:00.000000','2017-07-07 16:30:00.000000',4,22,NULL,'UE3','','2016-12-19 17:58:19.022510','2016-12-19 18:00:08.029271',1);
INSERT INTO "cours" VALUES(54,'2017-07-08 09:00:00.000000','2017-07-08 12:00:00.000000',4,14,NULL,'EU2','Examen UE2','2016-12-19 17:59:17.689413','2016-12-19 17:59:17.689413',1);
INSERT INTO "cours" VALUES(55,'2016-02-14 09:00:00.000000','2016-02-14 12:00:00.000000',4,7,9,'1','test BFM','2016-12-22 11:32:21.669713','2016-12-22 15:11:27.666590',3);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar DEFAULT '' NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar, "last_sign_in_ip" varchar, "created_at" datetime, "updated_at" datetime, "admin" boolean, "default" false, "formation_id" integer);
INSERT INTO "users" VALUES(1,'philippe.nougaillon@gmail.com','$2a$10$UMUQSLJVa6DGXYWCwi0sWuxSklvBLAX9Zqstrdu8I4BAY8YN4acjm',NULL,NULL,'2016-12-22 18:44:11.703795',36,'2016-12-22 18:44:11.742660','2016-12-22 15:30:12.867836','192.168.0.254','192.168.0.254','2016-12-15 13:27:53.341835','2016-12-22 18:44:11.743315','t',NULL,NULL);
INSERT INTO "users" VALUES(2,'toto@gmail.com','$2a$10$YimHyD.dTRMOczfA33cSI.rn7lcBH36T6QEHlcmkCDNyYyWI98DPi',NULL,NULL,NULL,12,'2016-12-22 09:05:39.904628','2016-12-20 17:17:33.880804','127.0.0.1','127.0.0.1','2016-12-15 13:43:41.137861','2016-12-22 09:05:39.905577',NULL,NULL,4);
INSERT INTO "users" VALUES(3,'philippe.eynaud@univ-paris1.fr','$2a$10$nyzz6EAGHP75O5LfPcJq6OxebWI908/yUwCWwEvYXR5g8WKVoqUYu',NULL,NULL,NULL,2,'2016-12-22 10:20:00.530567','2016-12-22 09:17:00.848398','81.57.212.136','192.168.0.254','2016-12-22 06:00:46.792157','2016-12-22 16:34:20.716702','t',NULL,4);
INSERT INTO "users" VALUES(4,'dominique.riviere@univ-paris1.fr','$2a$10$zMUtxYuCatRww6hRXxfsOeJnPNKWXPe2qYENwXkMtQK4cUvXCmbne',NULL,NULL,NULL,1,'2016-12-22 10:42:34.482460','2016-12-22 10:42:34.482460','192.168.0.254','192.168.0.254','2016-12-22 06:03:44.193215','2016-12-22 10:42:34.483114','t',NULL,NULL);
INSERT INTO "users" VALUES(5,'hannah@gmail.com','$2a$10$YneZEelhCX8zJKslTy/O2efUuFkRLA9Zw53iW4O1AhVnsj5eGX6Xe',NULL,NULL,NULL,1,'2016-12-22 15:29:56.079048','2016-12-22 15:29:56.079048','192.168.0.254','192.168.0.254','2016-12-22 06:06:49.616357','2016-12-22 15:29:56.079880','f',NULL,4);
INSERT INTO "users" VALUES(6,'fitsch-mouras.iae@univ-paris1.fr','$2a$10$0pIPu10/jxPVWNzC9fFdTuNEdt/I3h2mEu7NCfqABbyKA0Kk72X06',NULL,NULL,NULL,1,'2016-12-22 11:29:58.520332','2016-12-22 11:29:58.520332','86.246.195.68','86.246.195.68','2016-12-22 10:41:19.835422','2016-12-22 11:29:58.521015','t',NULL,NULL);
CREATE TABLE "audits" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "auditable_id" integer, "auditable_type" varchar, "associated_id" integer, "associated_type" varchar, "user_id" integer, "user_type" varchar, "username" varchar, "action" varchar, "audited_changes" text, "version" integer DEFAULT 0, "comment" varchar, "remote_address" varchar, "request_uuid" varchar, "created_at" datetime);
INSERT INTO "audits" VALUES(1,1,'Cour',NULL,NULL,1,'User',NULL,'update','---
etat:
- placé
- 0
',1,NULL,'127.0.0.1','564069ae-9f17-41ba-b77f-a32b7515942c','2016-12-15 14:03:01.191802');
INSERT INTO "audits" VALUES(2,1,'Cour',NULL,NULL,1,'User',NULL,'update','---
ue:
- UE9
- UE6
',2,NULL,'127.0.0.1','9f301353-27c3-409e-91b6-c8a8ae9e688e','2016-12-15 14:16:59.763369');
INSERT INTO "audits" VALUES(3,2,'Cour',NULL,NULL,1,'User',NULL,'update','---
etat:
- a_placer
- 1
',1,NULL,'127.0.0.1','2f29abe4-1ea3-4df3-a30e-33d892199195','2016-12-15 14:53:41.269570');
INSERT INTO "audits" VALUES(4,4,'Cour',NULL,NULL,1,'User',NULL,'update','---
etat:
- nouveau
- 2
',1,NULL,'127.0.0.1','75307719-de71-4a22-a49f-874a93f650d2','2016-12-15 14:54:38.024446');
INSERT INTO "audits" VALUES(5,1,'Cour',NULL,NULL,1,'User',NULL,'update','---
etat:
- nouveau
- 3
',3,NULL,'127.0.0.1','90d2bfd6-862f-457a-8ca1-661c6a0af484','2016-12-15 14:54:49.645813');
INSERT INTO "audits" VALUES(6,4,'Cour',NULL,NULL,2,'User',NULL,'update','---
salle_id:
- 
- 8
etat:
- a_placer
- 3
',2,NULL,'127.0.0.1','69a77073-a378-4f79-9c38-6a9049a0bfe9','2016-12-16 09:25:37.479973');
INSERT INTO "audits" VALUES(7,1,'Cour',NULL,NULL,1,'User',NULL,'update','---
salle_id:
- 1
- 2
',4,NULL,'127.0.0.1','ac2a0db3-9822-46bd-86f8-59a88e61c321','2016-12-16 14:32:40.790487');
INSERT INTO "audits" VALUES(8,7,'Cour',NULL,NULL,1,'User',NULL,'update','---
salle_id:
- 
- 1
etat:
- nouveau
- 3
',1,NULL,'127.0.0.1','a930dd1f-4db7-4cf9-90a4-08d0b18db390','2016-12-16 15:30:16.435649');
INSERT INTO "audits" VALUES(9,13,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-01-11 09:00:00.000000000 Z
fin: 2016-01-11 08:30:00.000000000 Z
formation_id: 4
intervenant_id: 11
salle_id: 
ue: ''''
nom: Réunion de Rentrée
etat: 1
',1,NULL,'127.0.0.1','8e4122c4-54d2-4ff1-8636-73f98345bc2f','2016-12-19 10:37:57.239320');
INSERT INTO "audits" VALUES(10,13,'Cour',NULL,NULL,1,'User',NULL,'update','---
fin:
- 2016-01-11 08:30:00.000000000 Z
- 2017-01-11 09:30:00.000000000 Z
',2,NULL,'127.0.0.1','8373e8ec-ed8f-4b17-aa20-9b18fecede67','2016-12-19 10:39:01.225552');
INSERT INTO "audits" VALUES(11,14,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-01-17 09:30:00.000000000 Z
fin: 2017-01-17 12:30:00.000000000 Z
formation_id: 4
intervenant_id: 12
salle_id: 
ue: UE9
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','dbe40102-fee3-4268-b815-badf92cd0e1e','2016-12-19 10:49:17.603838');
INSERT INTO "audits" VALUES(12,15,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-01-17 14:00:00.000000000 Z
fin: 2017-01-17 17:00:00.000000000 Z
formation_id: 4
intervenant_id: 12
salle_id: 
ue: UE9
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','db8aa898-4f36-441a-a007-3ae9c5f5ac78','2016-12-19 10:49:48.995468');
INSERT INTO "audits" VALUES(13,14,'Cour',NULL,NULL,1,'User',NULL,'update','---
debut:
- 2017-01-17 09:30:00.000000000 Z
- 2017-01-11 09:30:00.000000000 Z
fin:
- 2017-01-17 12:30:00.000000000 Z
- 2017-01-11 12:30:00.000000000 Z
',2,NULL,'127.0.0.1','1295e7ba-d1c7-4a7a-ba83-4e87df552828','2016-12-19 10:50:15.116504');
INSERT INTO "audits" VALUES(14,15,'Cour',NULL,NULL,1,'User',NULL,'update','---
debut:
- 2017-01-17 14:00:00.000000000 Z
- 2017-01-11 14:00:00.000000000 Z
fin:
- 2017-01-17 17:00:00.000000000 Z
- 2017-01-11 17:00:00.000000000 Z
',2,NULL,'127.0.0.1','af17b0b6-0abd-4f8e-bb59-e020988a62a6','2016-12-19 10:50:28.969451');
INSERT INTO "audits" VALUES(15,16,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-01-12 09:00:00.000000000 Z
fin: 2017-01-12 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 13
salle_id: 
ue: UE2
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','85576db0-6896-4b12-9ed5-aced4b43b2cf','2016-12-19 11:04:27.370048');
INSERT INTO "audits" VALUES(16,17,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-01-12 13:30:00.000000000 Z
fin: 2017-01-12 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 13
salle_id: 
ue: UE2
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','6fbc2d12-90a7-4f70-9f9e-888287018c01','2016-12-19 11:05:22.255480');
INSERT INTO "audits" VALUES(17,18,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-01-12 16:30:00.000000000 Z
fin: 2017-01-12 17:30:00.000000000 Z
formation_id: 4
intervenant_id: 13
salle_id: 
ue: UE9
nom: Fiche de lecture
etat: 1
',1,NULL,'127.0.0.1','cccda44c-7cd5-4cfe-bb82-8b5f47e3db4d','2016-12-19 11:07:28.157895');
INSERT INTO "audits" VALUES(18,19,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-01-12 18:30:00.000000000 Z
fin: 2017-01-12 20:00:00.000000000 Z
formation_id: 4
intervenant_id: 11
salle_id: 
ue: ''''
nom: Conférence Chaire MAI
etat: 1
',1,NULL,'127.0.0.1','e22c7b1b-2b9c-46fd-93f8-d6cc83846cf4','2016-12-19 11:09:09.113901');
INSERT INTO "audits" VALUES(19,20,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-01-13 09:00:00.000000000 Z
fin: 2017-01-13 09:30:00.000000000 Z
formation_id: 4
intervenant_id: 13
salle_id: 
ue: UE2
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','234c1ecc-4a8b-45f4-af2e-e4a7cc54fdbf','2016-12-19 11:12:09.189489');
INSERT INTO "audits" VALUES(20,20,'Cour',NULL,NULL,1,'User',NULL,'update','---
fin:
- 2017-01-13 09:30:00.000000000 Z
- 2017-01-13 10:30:00.000000000 Z
',2,NULL,'127.0.0.1','ca70309a-f53b-45d5-826a-d5a4a2fc30f5','2016-12-19 11:12:38.920957');
INSERT INTO "audits" VALUES(21,21,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-01-13 12:00:00.000000000 Z
fin: 2017-01-13 13:00:00.000000000 Z
formation_id: 4
intervenant_id: 14
salle_id: 
ue: ''''
nom: Apéritif inter-promotions
etat: 1
',1,NULL,'127.0.0.1','3a6a0111-c35a-4199-9985-0fd2f9b9e53f','2016-12-19 11:15:42.727190');
INSERT INTO "audits" VALUES(22,22,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-01-13 13:30:00.000000000 Z
fin: 2017-01-13 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 13
salle_id: 
ue: UE2
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','a9e7863b-f909-4977-85d4-4679c93d6f98','2016-12-19 11:16:13.441611');
INSERT INTO "audits" VALUES(23,23,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-02-15 09:00:00.000000000 Z
fin: 2017-02-15 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 11
salle_id: 
ue: UE9
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','faa9e5f2-1bc1-44c3-ac16-4843ef4a0bcf','2016-12-19 11:24:05.275920');
INSERT INTO "audits" VALUES(24,24,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-02-15 13:30:00.000000000 Z
fin: 2017-02-15 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 11
salle_id: 
ue: UE9
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','3f26455e-bab6-43bc-82f2-728a7140320b','2016-12-19 11:26:06.527880');
INSERT INTO "audits" VALUES(25,25,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-02-16 09:00:00.000000000 Z
fin: 2017-02-16 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 15
salle_id: 
ue: UE3
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','c8030b10-83dd-4296-8e09-ffd440b820ac','2016-12-19 11:28:40.888026');
INSERT INTO "audits" VALUES(26,26,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-02-16 13:30:00.000000000 Z
fin: 2017-02-16 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 12
salle_id: 
ue: UE9
nom: Présentation du Projet transversal et méthodologie
etat: 1
',1,NULL,'127.0.0.1','184d6657-87b0-46ef-b97e-551083f165f3','2016-12-19 11:30:21.049086');
INSERT INTO "audits" VALUES(27,27,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-02-17 09:00:00.000000000 Z
fin: 2017-02-17 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 16
salle_id: 
ue: UE1
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','c23a76fa-67e7-4db6-849c-e2f9f1fbe3cd','2016-12-19 11:31:31.015504');
INSERT INTO "audits" VALUES(28,28,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-02-17 13:00:00.000000000 Z
fin: 2017-02-17 16:00:00.000000000 Z
formation_id: 4
intervenant_id: 16
salle_id: 
ue: UE1
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','657e668c-cb66-4119-a8b8-77494b4040f8','2016-12-19 11:31:44.081715');
INSERT INTO "audits" VALUES(29,29,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-03-15 09:00:00.000000000 Z
fin: 2017-03-15 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 15
salle_id: 
ue: EU3
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','deacc7c6-f5bf-4902-9574-d5296b4e52fa','2016-12-19 15:49:52.839852');
INSERT INTO "audits" VALUES(30,30,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-03-15 13:30:00.000000000 Z
fin: 2017-03-15 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 15
salle_id: 
ue: EU3
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','5dd4bb37-d823-4bca-93ee-9a09835c7f37','2016-12-19 15:50:20.219758');
INSERT INTO "audits" VALUES(31,31,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-03-16 09:00:00.000000000 Z
fin: 2017-03-16 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 15
salle_id: 
ue: EU1
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','8a347bb1-fee8-40f6-90e7-d70ea68effbc','2016-12-19 15:51:45.614669');
INSERT INTO "audits" VALUES(32,31,'Cour',NULL,NULL,NULL,NULL,NULL,'update','---
intervenant_id:
- 15
- 17
',2,NULL,NULL,'0385e0b7-a651-4f70-85a0-27d0a168c720','2016-12-19 15:53:23.950942');
INSERT INTO "audits" VALUES(33,32,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-03-16 13:30:00.000000000 Z
fin: 2017-03-16 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 17
salle_id: 
ue: EU1
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','76bdda79-62f6-43b8-bcbd-effd890d4122','2016-12-19 15:53:53.042754');
INSERT INTO "audits" VALUES(34,33,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-03-17 09:00:00.000000000 Z
fin: 2017-03-17 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 17
salle_id: 
ue: EU9
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','399f6959-e0c5-4284-b9f6-a4de205fe307','2016-12-19 15:56:10.729955');
INSERT INTO "audits" VALUES(35,33,'Cour',NULL,NULL,NULL,NULL,NULL,'update','---
intervenant_id:
- 17
- 18
',2,NULL,NULL,'709f0ae5-cfbb-42f2-a064-df03e8c72221','2016-12-19 15:56:31.833563');
INSERT INTO "audits" VALUES(36,34,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-03-17 13:30:00.000000000 Z
fin: 2017-03-17 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 17
salle_id: 
ue: EU9
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','205e9c4c-08b6-42e6-9b86-b6389065e3e5','2016-12-19 15:57:03.042898');
INSERT INTO "audits" VALUES(37,34,'Cour',NULL,NULL,NULL,NULL,NULL,'update','---
intervenant_id:
- 17
- 18
',2,NULL,NULL,'9f7e06fc-488f-4db9-9300-7e131ff3e066','2016-12-19 15:57:11.085995');
INSERT INTO "audits" VALUES(38,29,'Cour',NULL,NULL,1,'User',NULL,'update','---
ue:
- EU3
- UE3
',2,NULL,'127.0.0.1','c2cdb02a-a54c-4222-a5c4-ad5ad112b5a9','2016-12-19 16:07:00.094570');
INSERT INTO "audits" VALUES(39,30,'Cour',NULL,NULL,1,'User',NULL,'update','---
ue:
- EU3
- UE3
',2,NULL,'127.0.0.1','eacc4d8b-8552-4cc5-b598-52e3e76d24b4','2016-12-19 16:07:15.965271');
INSERT INTO "audits" VALUES(40,31,'Cour',NULL,NULL,1,'User',NULL,'update','---
ue:
- EU1
- UE1
',3,NULL,'127.0.0.1','38dcc83b-c0dd-4fe6-b637-bacee13a7c81','2016-12-19 16:09:49.314124');
INSERT INTO "audits" VALUES(41,32,'Cour',NULL,NULL,1,'User',NULL,'update','---
ue:
- EU1
- UE1
',2,NULL,'127.0.0.1','5eb14666-580c-4e7f-a980-d4ca75d20d06','2016-12-19 16:10:04.266577');
INSERT INTO "audits" VALUES(42,33,'Cour',NULL,NULL,1,'User',NULL,'update','---
ue:
- EU9
- UE9
',3,NULL,'127.0.0.1','3a0b6b1e-09d5-48b4-bcbf-7cde6820f4c6','2016-12-19 16:10:19.469092');
INSERT INTO "audits" VALUES(43,34,'Cour',NULL,NULL,1,'User',NULL,'update','---
ue:
- EU9
- UE9
',3,NULL,'127.0.0.1','cb5aba23-04a1-400c-a3dc-2144509eb7ab','2016-12-19 16:10:36.914443');
INSERT INTO "audits" VALUES(44,35,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-05-17 09:00:00.000000000 Z
fin: 2017-05-17 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 21
salle_id: 
ue: UE3
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','0299a40a-1949-497d-979e-69b46bd90a71','2016-12-19 17:40:36.820309');
INSERT INTO "audits" VALUES(45,36,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-05-17 13:30:00.000000000 Z
fin: 2017-05-17 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 21
salle_id: 
ue: UE3
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','5e96fb18-98d0-4caa-bec6-e3b041b1271a','2016-12-19 17:40:58.155167');
INSERT INTO "audits" VALUES(46,37,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-05-17 16:45:00.000000000 Z
fin: 2017-05-17 17:45:00.000000000 Z
formation_id: 4
intervenant_id: 12
salle_id: 
ue: UE9
nom: Méthodologie Mémoire
etat: 1
',1,NULL,'127.0.0.1','c51c2a7f-1254-4d31-89df-de8db71fe2da','2016-12-19 17:41:45.433711');
INSERT INTO "audits" VALUES(47,38,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-05-18 09:00:00.000000000 Z
fin: 2017-05-18 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 19
salle_id: 
ue: UE2
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','de9a3226-ce3a-4d4b-bb9a-574e962b0028','2016-12-19 17:42:28.131149');
INSERT INTO "audits" VALUES(48,39,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-05-18 13:30:00.000000000 Z
fin: 2017-05-18 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 19
salle_id: 
ue: UE2
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','f4a77533-5ced-494b-9826-6c14f8204757','2016-12-19 17:42:57.560983');
INSERT INTO "audits" VALUES(49,40,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-05-19 09:00:00.000000000 Z
fin: 2017-05-19 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 20
salle_id: 
ue: UE1
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','3fafa307-16cc-4d64-b94b-f6bc2bfef269','2016-12-19 17:44:05.355075');
INSERT INTO "audits" VALUES(50,41,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-05-19 13:30:00.000000000 Z
fin: 2017-05-19 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 20
salle_id: 
ue: UE1
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','2174f10a-805b-48b0-a051-c307c71ddc3c','2016-12-19 17:44:23.637617');
INSERT INTO "audits" VALUES(51,42,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-06-14 09:00:00.000000000 Z
fin: 2017-06-14 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 14
salle_id: 
ue: ??
nom: ! ''???? ''
etat: 1
',1,NULL,'127.0.0.1','ac663e11-5175-4149-a644-920bd166ea33','2016-12-19 17:48:30.506149');
INSERT INTO "audits" VALUES(52,43,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-06-14 13:30:00.000000000 Z
fin: 2017-06-14 15:30:00.000000000 Z
formation_id: 4
intervenant_id: 12
salle_id: 
ue: UE9
nom: Méthodologies
etat: 1
',1,NULL,'127.0.0.1','93245a8f-2612-4cdd-9169-fa1cda92e6eb','2016-12-19 17:49:10.504201');
INSERT INTO "audits" VALUES(53,44,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-06-15 09:00:00.000000000 Z
fin: 2017-06-15 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 20
salle_id: 
ue: UE1
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','b6eaf05a-c810-4a0a-9a24-7ef44dee067d','2016-12-19 17:50:17.166101');
INSERT INTO "audits" VALUES(54,45,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-06-15 13:30:00.000000000 Z
fin: 2017-06-15 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 20
salle_id: 
ue: UE1
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','fa7c70e6-e616-4180-9da6-06e173b6de92','2016-12-19 17:51:02.833093');
INSERT INTO "audits" VALUES(55,46,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-06-16 09:00:00.000000000 Z
fin: 2017-06-16 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 20
salle_id: 
ue: UE9
nom: Secteur Associatif - ESS
etat: 1
',1,NULL,'127.0.0.1','f6573304-b024-450b-8640-bacda45dac97','2016-12-19 17:51:46.996446');
INSERT INTO "audits" VALUES(56,47,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-06-16 13:30:00.000000000 Z
fin: 2017-06-16 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 14
salle_id: 
ue: UE9
nom: Présentation Fiche de Lecture T. Wiedemann-Goiran
etat: 1
',1,NULL,'127.0.0.1','ab823ed1-909c-4073-92d5-743259c0be60','2016-12-19 17:52:39.257695');
INSERT INTO "audits" VALUES(57,48,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-07-05 09:00:00.000000000 Z
fin: 2017-07-05 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 18
salle_id: 
ue: UE3
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','602fa0fa-bf3b-43be-a218-989b12b1145f','2016-12-19 17:54:54.788829');
INSERT INTO "audits" VALUES(58,49,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-07-05 13:30:00.000000000 Z
fin: 2017-07-05 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 22
salle_id: 
ue: UE3
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','ffc4bde1-fbba-419e-90f7-52c0469846cc','2016-12-19 17:55:47.998295');
INSERT INTO "audits" VALUES(59,50,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-07-06 09:00:00.000000000 Z
fin: 2017-07-06 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 20
salle_id: 
ue: UE9
nom: Projet Transversal - 1ère Partie
etat: 1
',1,NULL,'127.0.0.1','f2eb63d7-c60d-4e87-911f-5c3562dbc971','2016-12-19 17:56:38.065040');
INSERT INTO "audits" VALUES(60,51,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-07-06 13:30:00.000000000 Z
fin: 2017-07-06 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 14
salle_id: 
ue: ??
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','1c434151-f874-40c9-a42a-d23e80b1081e','2016-12-19 17:57:20.386981');
INSERT INTO "audits" VALUES(61,52,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-07-07 09:00:00.000000000 Z
fin: 2017-07-07 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 22
salle_id: 
ue: EU3
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','d6793bb1-fa26-4ad3-abed-ba9c5f7339c0','2016-12-19 17:58:02.704812');
INSERT INTO "audits" VALUES(62,53,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-07-07 13:30:00.000000000 Z
fin: 2017-07-07 16:30:00.000000000 Z
formation_id: 4
intervenant_id: 22
salle_id: 
ue: EU3
nom: ''''
etat: 1
',1,NULL,'127.0.0.1','a07377fa-4f86-406a-9ccc-b2b06f9d8255','2016-12-19 17:58:19.025343');
INSERT INTO "audits" VALUES(63,54,'Cour',NULL,NULL,1,'User',NULL,'create','---
debut: 2017-07-08 09:00:00.000000000 Z
fin: 2017-07-08 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 14
salle_id: 
ue: EU2
nom: Examen UE2
etat: 1
',1,NULL,'127.0.0.1','2eac2ffe-f756-4781-9d88-579ace41eb76','2016-12-19 17:59:17.692548');
INSERT INTO "audits" VALUES(64,52,'Cour',NULL,NULL,1,'User',NULL,'update','---
ue:
- EU3
- UE3
',2,NULL,'127.0.0.1','8add4e39-b66f-4db6-8987-9b88dadf1cd9','2016-12-19 17:59:40.725545');
INSERT INTO "audits" VALUES(65,53,'Cour',NULL,NULL,1,'User',NULL,'update','---
ue:
- EU3
- UE3
',2,NULL,'127.0.0.1','fe1dc219-5084-4da1-8fd1-7f305c5bb37f','2016-12-19 18:00:08.030953');
INSERT INTO "audits" VALUES(66,47,'Cour',NULL,NULL,1,'User',NULL,'update','---
intervenant_id:
- 14
- 23
nom:
- Présentation Fiche de Lecture T. Wiedemann-Goiran
- Présentation Fiche de Lecture
',2,NULL,'127.0.0.1','341aeb69-55f2-414f-a7a5-c5984a1c5fe1','2016-12-19 18:01:17.894143');
INSERT INTO "audits" VALUES(67,3,'Cour',NULL,NULL,1,'User',NULL,'update','---
etat:
- nouveau
- 3
',1,NULL,'127.0.0.1','ca01f5c1-6cb0-42ee-8223-3ff5d6007b63','2016-12-21 11:41:25.985328');
INSERT INTO "audits" VALUES(68,13,'Cour',NULL,NULL,1,'User',NULL,'update','---
etat:
- plannifié
- 2
',3,NULL,'127.0.0.1','1ec1a4cd-6b45-4ae9-b792-2b305c94ce17','2016-12-21 11:53:11.253132');
INSERT INTO "audits" VALUES(69,15,'Cour',NULL,NULL,1,'User',NULL,'update','---
etat:
- plannifié
- 3
',3,NULL,'127.0.0.1','d915efc8-dfad-4571-af68-d65e30bf4e11','2016-12-21 11:54:17.169037');
INSERT INTO "audits" VALUES(70,2,'Cour',NULL,NULL,1,'User',NULL,'update','---
salle_id:
- 
- 10
',2,NULL,'127.0.0.1','dea88f04-0c56-4676-811a-9edf2955d544','2016-12-21 12:23:02.358798');
INSERT INTO "audits" VALUES(71,13,'Cour',NULL,NULL,6,'User',NULL,'update','---
fin:
- 2017-01-11 09:30:00.000000000 Z
- 2017-01-11 09:45:00.000000000 Z
',4,NULL,'86.246.195.68','d8923880-5859-4906-95c2-c9cbf7181694','2016-12-22 11:30:37.074129');
INSERT INTO "audits" VALUES(72,55,'Cour',NULL,NULL,6,'User',NULL,'create','---
debut: 2016-02-14 09:00:00.000000000 Z
fin: 2016-02-14 12:00:00.000000000 Z
formation_id: 4
intervenant_id: 7
salle_id: 9
ue: ''1''
nom: test BFM
etat: 1
',1,NULL,'86.246.195.68','db7cc3b6-bde3-4678-86b3-ef088691ea1a','2016-12-22 11:32:21.672598');
INSERT INTO "audits" VALUES(73,55,'Cour',NULL,NULL,1,'User',NULL,'update','---
etat:
- planifié
- 3
',2,NULL,'192.168.0.254','d5c92e21-055a-43d6-a5f6-c5bc4e0351a1','2016-12-22 15:11:27.668321');
CREATE TABLE "unites" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "formation_id" integer, "nom" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "num" varchar);
INSERT INTO "unites" VALUES(1,1,'TEST EU #1','2016-12-19 09:37:27.246150','2016-12-19 15:32:54.843347','EU1');
INSERT INTO "unites" VALUES(2,4,'Socio-économie des Associations','2016-12-19 10:08:57.483390','2016-12-19 10:08:57.483390','UE1');
INSERT INTO "unites" VALUES(3,4,'Environnement juridique administratif et fiscal','2016-12-19 10:12:21.109260','2016-12-19 10:12:21.109260','UE2');
INSERT INTO "unites" VALUES(4,4,'Management des ressources humaines','2016-12-19 10:12:21.110059','2016-12-19 15:58:06.876862','UE3');
INSERT INTO "unites" VALUES(5,4,'Management des systèmes d''information et de communication  (1ère année et 2ème année)','2016-12-19 10:13:47.435345','2016-12-19 10:13:47.435345','UE4');
INSERT INTO "unites" VALUES(6,4,'Management financier (1ère et 2ème année)','2016-12-19 10:13:47.436148','2016-12-19 10:13:47.436148','UE5');
INSERT INTO "unites" VALUES(7,4,'Pilotage des activités et développement des performances (2ème année)','2016-12-19 10:15:20.365843','2016-12-19 15:58:06.877694','UE6');
INSERT INTO "unites" VALUES(8,4,'Marketing et communication (2ème année)','2016-12-19 10:15:20.366589','2016-12-19 10:15:20.366589','UE7');
INSERT INTO "unites" VALUES(9,4,'Management Stratégique et gouvernance (1ère et 2ème année)','2016-12-19 10:16:13.754050','2016-12-19 10:16:13.754050','UE8');
INSERT INTO "unites" VALUES(10,4,'Pratique et connaissance des organisations et des institutions (1ère et 2ème année)','2016-12-19 10:16:13.754985','2016-12-19 10:22:16.816931','UE9');
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('formations',5);
INSERT INTO "sqlite_sequence" VALUES('intervenants',23);
INSERT INTO "sqlite_sequence" VALUES('salles',11);
INSERT INTO "sqlite_sequence" VALUES('cours',55);
INSERT INTO "sqlite_sequence" VALUES('users',6);
INSERT INTO "sqlite_sequence" VALUES('audits',73);
INSERT INTO "sqlite_sequence" VALUES('unites',10);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE INDEX "index_cours_on_formation_id" ON "cours" ("formation_id");
CREATE INDEX "index_cours_on_intervenant_id" ON "cours" ("intervenant_id");
CREATE INDEX "index_cours_on_salle_id" ON "cours" ("salle_id");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE INDEX "auditable_index" ON "audits" ("auditable_id", "auditable_type");
CREATE INDEX "associated_index" ON "audits" ("associated_id", "associated_type");
CREATE INDEX "user_index" ON "audits" ("user_id", "user_type");
CREATE INDEX "index_audits_on_request_uuid" ON "audits" ("request_uuid");
CREATE INDEX "index_audits_on_created_at" ON "audits" ("created_at");
CREATE INDEX "index_unites_on_formation_id" ON "unites" ("formation_id");
CREATE INDEX "index_users_on_formation_id" ON "users" ("formation_id");
COMMIT;
