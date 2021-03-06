
--
-- Create model ContentType
--
CREATE TABLE "DJANGO_CONTENT_TYPE" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "NAME" NVARCHAR2(100) NULL, "APP_LABEL" NVARCHAR2(100) NULL, "MODEL" NVARCHAR2(100) NULL);
--
-- Alter unique_together for contenttype (1 constraint(s))
--
ALTER TABLE "DJANGO_CONTENT_TYPE" ADD CONSTRAINT "DJANGO_CO_APP_LABEL_76BD3D3B_U" UNIQUE ("APP_LABEL", "MODEL");

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'DJANGO_CONTENT_TYPE_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "DJANGO_CONTENT_TYPE_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "DJANGO_CONTENT_TYPE_TR"
BEFORE INSERT ON "DJANGO_CONTENT_TYPE"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "DJANGO_CONTENT_TYPE_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
COMMIT;

--
-- Create model Permission
--
CREATE TABLE "AUTH_PERMISSION" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "NAME" NVARCHAR2(50) NULL, "CONTENT_TYPE_ID" NUMBER(11) NOT NULL, "CODENAME" NVARCHAR2(100) NULL);
--
-- Create model Group
--
CREATE TABLE "AUTH_GROUP" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "NAME" NVARCHAR2(80) NULL UNIQUE);
CREATE TABLE "AUTH_GROUP_PERMISSIONS" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "GROUP_ID" NUMBER(11) NOT NULL, "PERMISSION_ID" NUMBER(11) NOT NULL);
--
-- Create model User
--
CREATE TABLE "AUTH_USER" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "PASSWORD" NVARCHAR2(128) NULL, "LAST_LOGIN" TIMESTAMP NOT NULL, "IS_SUPERUSER" NUMBER(1) NOT NULL CHECK ("IS_SUPERUSER" IN (0,1)), "USERNAME" NVARCHAR2(30) NULL UNIQUE, "FIRST_NAME" NVARCHAR2(30) NULL, "LAST_NAME" NVARCHAR2(30) NULL, "EMAIL" NVARCHAR2(75) NULL, "IS_STAFF" NUMBER(1) NOT NULL CHECK ("IS_STAFF" IN (0,1)), "IS_ACTIVE" NUMBER(1) NOT NULL CHECK ("IS_ACTIVE" IN (0,1)), "DATE_JOINED" TIMESTAMP NOT NULL);
CREATE TABLE "AUTH_USER_GROUPS" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "USER_ID" NUMBER(11) NOT NULL, "GROUP_ID" NUMBER(11) NOT NULL);
CREATE TABLE "AUTH_USER_USER_PERMISSIONS" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "USER_ID" NUMBER(11) NOT NULL, "PERMISSION_ID" NUMBER(11) NOT NULL);

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_PERMISSION_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_PERMISSION_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_PERMISSION_TR"
BEFORE INSERT ON "AUTH_PERMISSION"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_PERMISSION_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "AUTH_PERMISSION" ADD CONSTRAINT "AUTH_PERM_CONTENT_T_2F476E4B_F" FOREIGN KEY ("CONTENT_TYPE_ID") REFERENCES "DJANGO_CONTENT_TYPE" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_PERMISSION" ADD CONSTRAINT "AUTH_PERM_CONTENT_T_01AB375A_U" UNIQUE ("CONTENT_TYPE_ID", "CODENAME");
CREATE INDEX "AUTH_PERMI_CONTENT_TY_2F476E4B" ON "AUTH_PERMISSION" ("CONTENT_TYPE_ID");

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_GROUP_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_GROUP_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_GROUP_TR"
BEFORE INSERT ON "AUTH_GROUP"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_GROUP_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_GROUP_PERMISSIONS_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_GROUP_PERMISSIONS_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_GROUP_PERMISSIONS_TR"
BEFORE INSERT ON "AUTH_GROUP_PERMISSIONS"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_GROUP_PERMISSIONS_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "AUTH_GROUP_PERMISSIONS" ADD CONSTRAINT "AUTH_GROU_GROUP_ID_B120CBF9_F" FOREIGN KEY ("GROUP_ID") REFERENCES "AUTH_GROUP" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_GROUP_PERMISSIONS" ADD CONSTRAINT "AUTH_GROU_PERMISSIO_84C5C92E_F" FOREIGN KEY ("PERMISSION_ID") REFERENCES "AUTH_PERMISSION" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_GROUP_PERMISSIONS" ADD CONSTRAINT "AUTH_GROU_GROUP_ID__0CD325B0_U" UNIQUE ("GROUP_ID", "PERMISSION_ID");
CREATE INDEX "AUTH_GROUP_GROUP_ID_B120CBF9" ON "AUTH_GROUP_PERMISSIONS" ("GROUP_ID");
CREATE INDEX "AUTH_GROUP_PERMISSION_84C5C92E" ON "AUTH_GROUP_PERMISSIONS" ("PERMISSION_ID");

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_USER_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_USER_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_USER_TR"
BEFORE INSERT ON "AUTH_USER"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_USER_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_USER_GROUPS_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_USER_GROUPS_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_USER_GROUPS_TR"
BEFORE INSERT ON "AUTH_USER_GROUPS"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_USER_GROUPS_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "AUTH_USER_GROUPS" ADD CONSTRAINT "AUTH_USER_USER_ID_6A12ED8B_F" FOREIGN KEY ("USER_ID") REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_USER_GROUPS" ADD CONSTRAINT "AUTH_USER_GROUP_ID_97559544_F" FOREIGN KEY ("GROUP_ID") REFERENCES "AUTH_GROUP" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_USER_GROUPS" ADD CONSTRAINT "AUTH_USER_USER_ID_G_94350C0C_U" UNIQUE ("USER_ID", "GROUP_ID");
CREATE INDEX "AUTH_USER__USER_ID_6A12ED8B" ON "AUTH_USER_GROUPS" ("USER_ID");
CREATE INDEX "AUTH_USER__GROUP_ID_97559544" ON "AUTH_USER_GROUPS" ("GROUP_ID");

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_USER_USER_PERMISSI7B1E';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_USER_USER_PERMISSI7B1E"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_USER_USER_PERMISSI17F3"
BEFORE INSERT ON "AUTH_USER_USER_PERMISSIONS"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_USER_USER_PERMISSI7B1E".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "AUTH_USER_USER_PERMISSIONS" ADD CONSTRAINT "AUTH_USER_USER_ID_A95EAD1B_F" FOREIGN KEY ("USER_ID") REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_USER_USER_PERMISSIONS" ADD CONSTRAINT "AUTH_USER_PERMISSIO_1FBB5F2C_F" FOREIGN KEY ("PERMISSION_ID") REFERENCES "AUTH_PERMISSION" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_USER_USER_PERMISSIONS" ADD CONSTRAINT "AUTH_USER_USER_ID_P_14A6B632_U" UNIQUE ("USER_ID", "PERMISSION_ID");
CREATE INDEX "AUTH_USER__USER_ID_A95EAD1B" ON "AUTH_USER_USER_PERMISSIONS" ("USER_ID");
CREATE INDEX "AUTH_USER__PERMISSION_1FBB5F2C" ON "AUTH_USER_USER_PERMISSIONS" ("PERMISSION_ID");
COMMIT;

--
-- Create model LogEntry
--
CREATE TABLE "DJANGO_ADMIN_LOG" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "ACTION_TIME" TIMESTAMP NOT NULL, "OBJECT_ID" NCLOB NULL, "OBJECT_REPR" NVARCHAR2(200) NULL, "ACTION_FLAG" NUMBER(11) NOT NULL CHECK ("ACTION_FLAG" >= 0), "CHANGE_MESSAGE" NCLOB NULL, "CONTENT_TYPE_ID" NUMBER(11) NULL, "USER_ID" NUMBER(11) NOT NULL);

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'DJANGO_ADMIN_LOG_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "DJANGO_ADMIN_LOG_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "DJANGO_ADMIN_LOG_TR"
BEFORE INSERT ON "DJANGO_ADMIN_LOG"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "DJANGO_ADMIN_LOG_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "DJANGO_ADMIN_LOG" ADD CONSTRAINT "DJANGO_AD_CONTENT_T_C4BCE8EB_F" FOREIGN KEY ("CONTENT_TYPE_ID") REFERENCES "DJANGO_CONTENT_TYPE" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "DJANGO_ADMIN_LOG" ADD CONSTRAINT "DJANGO_AD_USER_ID_C564EBA6_F" FOREIGN KEY ("USER_ID") REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "DJANGO_ADM_CONTENT_TY_C4BCE8EB" ON "DJANGO_ADMIN_LOG" ("CONTENT_TYPE_ID");
CREATE INDEX "DJANGO_ADM_USER_ID_C564EBA6" ON "DJANGO_ADMIN_LOG" ("USER_ID");
COMMIT;

--
-- Change Meta options on contenttype
--
--
-- Alter field name on contenttype
--
--
-- MIGRATION NOW PERFORMS OPERATION THAT CANNOT BE WRITTEN AS SQL:
-- Raw Python operation
--
--
-- Remove field name from contenttype
--
ALTER TABLE "DJANGO_CONTENT_TYPE" DROP COLUMN "NAME";
COMMIT;

--
-- Alter field name on permission
--
ALTER TABLE "AUTH_PERMISSION" MODIFY "NAME" NVARCHAR2(255);
COMMIT;

--
-- Alter field email on user
--
ALTER TABLE "AUTH_USER" MODIFY "EMAIL" NVARCHAR2(254);
COMMIT;

--
-- Alter field last_login on user
--
ALTER TABLE "AUTH_USER" MODIFY "LAST_LOGIN" NULL;
COMMIT;

--
-- Alter field username on user
--
ALTER TABLE "AUTH_USER" MODIFY "USERNAME" NVARCHAR2(150);
COMMIT;

--
-- Create model Basket
--
CREATE TABLE "MAIN_LIST_BASKET" ("ID" NUMBER(11) NOT NULL PRIMARY KEY);
--
-- Create model Clothes
--
CREATE TABLE "MAIN_LIST_CLOTHES" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "NAME" NVARCHAR2(45) NULL, "DESCRIPTION" NVARCHAR2(200) NULL, "CLOTHES_TYPE" NVARCHAR2(50) NULL, "CATEGORY" NVARCHAR2(7) NULL, "QUANTITY" NUMBER(11) NOT NULL CHECK ("QUANTITY" >= 0), "PRICE" NUMBER(11) NOT NULL CHECK ("PRICE" >= 0));
--
-- Create model Order
--
CREATE TABLE "MAIN_LIST_ORDER" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "QUANTITY" NUMBER(11) NOT NULL CHECK ("QUANTITY" >= 0), "CREATE_TIME" TIMESTAMP NULL, "IS_PAYED" NUMBER(1) NULL CHECK (("IS_PAYED" IN (0,1)) OR ("IS_PAYED" IS NULL)), "CLOTHES_ID" NUMBER(11) NULL, "USER_ID" NUMBER(11) NULL);
--
-- Alter unique_together for clothes (1 constraint(s))
--
ALTER TABLE "MAIN_LIST_CLOTHES" ADD CONSTRAINT "MAIN_LIST_NAME_PRIC_21B9B703_U" UNIQUE ("NAME", "PRICE");
--
-- Add field order to basket
--
CREATE TABLE "MAIN_LIST_BASKET_ORDER" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "BASKET_ID" NUMBER(11) NOT NULL, "ORDER_ID" NUMBER(11) NOT NULL);
--
-- Add field user to basket
--
ALTER TABLE "MAIN_LIST_BASKET" ADD "USER_ID" NUMBER(11) NULL UNIQUE;

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'MAIN_LIST_BASKET_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "MAIN_LIST_BASKET_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "MAIN_LIST_BASKET_TR"
BEFORE INSERT ON "MAIN_LIST_BASKET"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "MAIN_LIST_BASKET_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'MAIN_LIST_CLOTHES_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "MAIN_LIST_CLOTHES_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "MAIN_LIST_CLOTHES_TR"
BEFORE INSERT ON "MAIN_LIST_CLOTHES"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "MAIN_LIST_CLOTHES_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'MAIN_LIST_ORDER_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "MAIN_LIST_ORDER_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "MAIN_LIST_ORDER_TR"
BEFORE INSERT ON "MAIN_LIST_ORDER"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "MAIN_LIST_ORDER_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "MAIN_LIST_ORDER" ADD CONSTRAINT "MAIN_LIST_CLOTHES_I_186D2AD5_F" FOREIGN KEY ("CLOTHES_ID") REFERENCES "MAIN_LIST_CLOTHES" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "MAIN_LIST_ORDER" ADD CONSTRAINT "MAIN_LIST_USER_ID_7F60981A_F" FOREIGN KEY ("USER_ID") REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "MAIN_LIST__CLOTHES_ID_186D2AD5" ON "MAIN_LIST_ORDER" ("CLOTHES_ID");
CREATE INDEX "MAIN_LIST__USER_ID_7F60981A" ON "MAIN_LIST_ORDER" ("USER_ID");

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'MAIN_LIST_BASKET_ORDER_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "MAIN_LIST_BASKET_ORDER_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "MAIN_LIST_BASKET_ORDER_TR"
BEFORE INSERT ON "MAIN_LIST_BASKET_ORDER"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "MAIN_LIST_BASKET_ORDER_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "MAIN_LIST_BASKET_ORDER" ADD CONSTRAINT "MAIN_LIST_BASKET_ID_CE18B012_F" FOREIGN KEY ("BASKET_ID") REFERENCES "MAIN_LIST_BASKET" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "MAIN_LIST_BASKET_ORDER" ADD CONSTRAINT "MAIN_LIST_ORDER_ID_ED6210C1_F" FOREIGN KEY ("ORDER_ID") REFERENCES "MAIN_LIST_ORDER" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "MAIN_LIST_BASKET_ORDER" ADD CONSTRAINT "MAIN_LIST_BASKET_ID_F02FC98F_U" UNIQUE ("BASKET_ID", "ORDER_ID");
CREATE INDEX "MAIN_LIST__BASKET_ID_CE18B012" ON "MAIN_LIST_BASKET_ORDER" ("BASKET_ID");
CREATE INDEX "MAIN_LIST__ORDER_ID_ED6210C1" ON "MAIN_LIST_BASKET_ORDER" ("ORDER_ID");
ALTER TABLE "MAIN_LIST_BASKET" ADD CONSTRAINT "MAIN_LIST_USER_ID_A6A7DD02_F" FOREIGN KEY ("USER_ID") REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED;
COMMIT;

--
-- Create model Session
--
CREATE TABLE "DJANGO_SESSION" ("SESSION_KEY" NVARCHAR2(40) NOT NULL PRIMARY KEY, "SESSION_DATA" NCLOB NULL, "EXPIRE_DATE" TIMESTAMP NOT NULL);
CREATE INDEX "DJANGO_SES_EXPIRE_DAT_A5C62663" ON "DJANGO_SESSION" ("EXPIRE_DATE");
COMMIT;

--
-- Customs
--
CREATE OR REPLACE PACKAGE ADMIN_PACKAGE IS
    PROCEDURE CREATE_CLOTHES (
      clothes_name VARCHAR2, 
      clothes_description VARCHAR2, 
      clothes_price NUMBER, 
      clothes_category VARCHAR2, 
      clothes_clothes_type VARCHAR2, 
      clothes_quantity NUMBER);
    PROCEDURE UPDATE_CLOTHES (
      updating_clothes_id NUMBER,
      clothes_name VARCHAR2, 
      clothes_description VARCHAR2, 
      clothes_price NUMBER, 
      clothes_category VARCHAR2, 
      clothes_clothes_type VARCHAR2, 
      clothes_quantity NUMBER);
    PROCEDURE DELETE_CLOTHES (
      deleting_clothes_id NUMBER);
END ADMIN_PACKAGE;
/
COMMIT;

CREATE OR REPLACE PACKAGE BODY ADMIN_PACKAGE IS 
    PROCEDURE CREATE_CLOTHES (
      clothes_name VARCHAR2, 
      clothes_description VARCHAR2, 
      clothes_price NUMBER, 
      clothes_category VARCHAR2, 
      clothes_clothes_type VARCHAR2, 
      clothes_quantity NUMBER) AS
        BEGIN
            INSERT INTO "MAIN_LIST_CLOTHES" (
              "NAME",
              "DESCRIPTION", 
              "PRICE", 
              "CATEGORY", 
              "CLOTHES_TYPE", 
              "QUANTITY")
            VALUES (
              clothes_name,
              clothes_description, 
              clothes_price, 
              clothes_category, 
              clothes_clothes_type, 
              clothes_quantity);
        END;

    PROCEDURE UPDATE_CLOTHES (
      updating_clothes_id NUMBER,
      clothes_name VARCHAR2, 
      clothes_description VARCHAR2, 
      clothes_price NUMBER, 
      clothes_category VARCHAR2, 
      clothes_clothes_type VARCHAR2, 
      clothes_quantity NUMBER) AS
        BEGIN
          UPDATE "MAIN_LIST_CLOTHES" SET
              "NAME" = clothes_name, 
              "DESCRIPTION" = clothes_description, 
              "PRICE" = clothes_price, 
              "CATEGORY" = clothes_category, 
              "CLOTHES_TYPE" = clothes_clothes_type,
              "QUANTITY" = clothes_quantity
            WHERE "ID" = updating_clothes_id;
        END;
     PROCEDURE DELETE_CLOTHES (
      deleting_clothes_id NUMBER) AS
        BEGIN
          DELETE "MAIN_LIST_CLOTHES" 
          WHERE "ID" = deleting_clothes_id;
        END;
END;
/
COMMIT;


CREATE OR REPLACE PACKAGE BASKET_PACKAGE IS
  PROCEDURE CREATE_BASKET (
    USER_ID NUMBER);
  PROCEDURE DELETE_ORDER_FROM_BASKET (
    ORDER_ID_TO_DELETE NUMBER);
END BASKET_PACKAGE;
/
COMMIT;

create or replace PACKAGE BODY BASKET_PACKAGE IS 
  PROCEDURE CREATE_BASKET (
    USER_ID NUMBER) AS
    BEGIN
      INSERT INTO "MAIN_LIST_BASKET" (
        "USER_ID")
      VALUES (USER_ID);
    END;
  PROCEDURE DELETE_ORDER_FROM_BASKET (
    ORDER_ID_TO_DELETE NUMBER) AS
    BEGIN
      DELETE "MAIN_LIST_BASKET_ORDER"
        WHERE "ORDER_ID" = ORDER_ID_TO_DELETE;
    END;
END;
/
COMMIT;


CREATE OR REPLACE PACKAGE ORDER_PACKAGE IS
  PROCEDURE CREATE_ORDER (
    ORDER_USER_ID NUMBER,
    ORDER_CLOTHES_ID NUMBER,
    ORDER_QUANTITY NUMBER,
    NEW_ID out NUMBER);
  PROCEDURE DELETE_ORDER (
    ORDER_ID_TO_DELETE NUMBER);
END ORDER_PACKAGE;
/
COMMIT;

CREATE OR REPLACE PACKAGE BODY ORDER_PACKAGE IS 
  PROCEDURE CREATE_ORDER (
    ORDER_USER_ID NUMBER,
    ORDER_CLOTHES_ID NUMBER,
    ORDER_QUANTITY NUMBER,
    NEW_ID out NUMBER) AS
    BEGIN
      INSERT INTO "MAIN_LIST_ORDER" ("USER_ID", "CLOTHES_ID", "QUANTITY")
      VALUES (ORDER_USER_ID, ORDER_CLOTHES_ID, ORDER_QUANTITY)
      RETURNING "ID" INTO NEW_ID;
    END;
  PROCEDURE DELETE_ORDER (
    ORDER_ID_TO_DELETE NUMBER) AS
    BEGIN
      DELETE "MAIN_LIST_ORDER"
      WHERE "ID" = ORDER_ID_TO_DELETE;
    END;
END;
/
COMMIT;



ALTER TABLE "MAIN_LIST_ORDER" DROP CONSTRAINT "MAIN_LIST_CLOTHES_I_186D2AD5_F";
ALTER TABLE "MAIN_LIST_ORDER" ADD CONSTRAINT "MAIN_LIST_CLOTHES_I_186D2AD5_F" FOREIGN KEY ("CLOTHES_ID") REFERENCES "MAIN_LIST_CLOTHES" ("ID") ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE "MAIN_LIST_BASKET_ORDER" DROP CONSTRAINT "MAIN_LIST_ORDER_ID_ED6210C1_F";
ALTER TABLE "MAIN_LIST_BASKET_ORDER" ADD CONSTRAINT "MAIN_LIST_ORDER_ID_ED6210C1_F" FOREIGN KEY ("ORDER_ID") REFERENCES "MAIN_LIST_ORDER" ("ID") ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


CREATE OR REPLACE PACKAGE BASKET_ORDER_PACKAGE IS
  PROCEDURE ADD_ORDER (
    ADD_BASKET_ID NUMBER,
    ADD_ORDER_ID NUMBER);
END BASKET_ORDER_PACKAGE;
/
COMMIT;

CREATE OR REPLACE PACKAGE BODY BASKET_ORDER_PACKAGE IS 
  PROCEDURE ADD_ORDER (
    ADD_BASKET_ID NUMBER,
    ADD_ORDER_ID NUMBER) AS
    BEGIN
      INSERT INTO "MAIN_LIST_BASKET_ORDER" ("BASKET_ID", "ORDER_ID")
      VALUES (ADD_BASKET_ID, ADD_ORDER_ID);
    END;
END;
/
COMMIT;


CREATE OR REPLACE PACKAGE BUY_BASKET_ORDER IS
  PROCEDURE BUY_ORDER (
    ORDER_ID NUMBER,
    CLOTHES_ID NUMBER,
    QUANTITY_TO_BUY NUMBER);
END BUY_BASKET_ORDER;
/
COMMIT;

CREATE OR REPLACE PACKAGE BODY BUY_BASKET_ORDER IS 
  PROCEDURE BUY_ORDER (
    ORDER_ID NUMBER,
    CLOTHES_ID NUMBER,
    QUANTITY_TO_BUY NUMBER) AS
    BEGIN
      UPDATE "MAIN_LIST_ORDER" SET
        "IS_PAYED" = 1
        WHERE "ID" = ORDER_ID;
      UPDATE "MAIN_LIST_CLOTHES" SET
        "QUANTITY" = "QUANTITY" - QUANTITY_TO_BUY
      WHERE "ID" = CLOTHES_ID;
    END;
END;
/
COMMIT;


CREATE OR REPLACE VIEW "ORDER_DETAILS_PAGE" AS 
  SELECT 
    "AUTH_USER"."USERNAME" "USERNAME", 

    "MAIN_LIST_CLOTHES"."NAME" "CLOTHES_NAME", 

    "MAIN_LIST_ORDER"."ID" "ORDER_ID", 
    "MAIN_LIST_ORDER"."QUANTITY" "ORDER_QUANTITY", 
    "MAIN_LIST_ORDER"."CREATE_TIME" "CREATE_TIME"

  FROM 
    "AUTH_USER" LEFT JOIN "MAIN_LIST_ORDER" ON "AUTH_USER"."ID" = "MAIN_LIST_ORDER"."USER_ID"
                LEFT JOIN "MAIN_LIST_CLOTHES" ON "MAIN_LIST_ORDER"."CLOTHES_ID" = "MAIN_LIST_CLOTHES"."ID";
COMMIT;

CREATE OR REPLACE TRIGGER ORDER_CREATE_TIME_NOW 
BEFORE INSERT ON MAIN_LIST_ORDER 
FOR EACH ROW
BEGIN
 :NEW.CREATE_TIME := SYSDATE;
END;
/
COMMIT;
