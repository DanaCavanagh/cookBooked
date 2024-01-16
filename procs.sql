-- ===================================================================
-- @authors: Dana Cavanagh, Connor George
-- created:	late dec. '23
-- last updated: jan. '24
-- purpose: the purpose of this document is to hold stored procedures
--          for data retrieval from the cookBooked database (with the 
-- 			intent of using a python connector)
-- ===================================================================

USE `cookBooked`;


/** 
params: an integer representing a typeID
returns: the name of that type (string)
this procedure is intended to allow the python connector to get the
name of a type from it's type ID number.
**/
DROP PROCEDURE IF EXISTS `getTypeName`;
DELIMITER $$
CREATE PROCEDURE `getTypeName`(IN TypeIDIN INT)
BEGIN
	SELECT name
    FROM   Type
    WHERE  Type.typeID = TypeIDIN ;
END$$
DELIMITER ;

/**
params: typeId INT
this procedure will return all of the ingredient in the type
indicated by the argument passed.
**/
DROP PROCEDURE IF EXISTS  `getIngredientsInType`;
DELIMITER $$
CREATE PROCEDURE `getIngredientsInType`(IN typeId INT)
BEGIN
	SELECT DISTINCT
    I.ingredientID
	FROM 
		Ingredient as I
	WHERE 
	I.ingredientID in(
		Select i.ingredientID from Ingredient as i
		inner join Ingredient_Type as it on i.ingredientID = it.ingredientID
		inner join Type as t on it.typeID = t.typeID
		where t.typeID = typeId
	);
END $$
DELIMITER ;



/** 
params: None
returns: a table datatype holding all of the food types in the database
this procedure returns all of the food types currently in the database.
**/
DROP PROCEDURE IF EXISTS `getAllTypes`;
DELIMITER $$
CREATE PROCEDURE `getAllTypes`()
BEGIN
	SELECT typeID
    FROM   Type ;
END$$
DELIMITER ;


/**
param: None
this procedure will return all of the cultures (their IDs) in the database.
**/
DROP PROCEDURE IF EXISTS `getAllCultures`;
DELIMITER $$
CREATE PROCEDURE `getAllCultures`()
BEGIN
	SELECT idCulture
    FROM   Culture ;
END$$
DELIMITER ;


/**
param: Id INT (culture ID)
this procedure will return the name of the culture whose ID is passed as an arg
**/
DROP PROCEDURE IF EXISTS `getCultureName`;
DELIMITER $$
CREATE PROCEDURE `getCultureName`(IN ID INT)
BEGIN
	SELECT name
    FROM   Culture
    WHERE  Culture.idCulture = ID ;
END$$
DELIMITER ;


/**
param: None.
this procedure returns all of the ingredients in the database (their IDs).
**/
DROP PROCEDURE IF EXISTS `getAllIngredients`;
DELIMITER $$
CREATE PROCEDURE `getAllIngredients`()
BEGIN
	SELECT ingredientID
    FROM   Ingredient ;
END$$
DELIMITER ;


/**
param: ID INT (ingredientID)
this procedure returns the name of an ingredient whose ID is passed in as an arg
**/
DROP PROCEDURE IF EXISTS `getIngredientName`;
DELIMITER $$
CREATE PROCEDURE `getIngredientName`(IN ID INT)
BEGIN
	SELECT name
    FROM   Ingredient
    WHERE  Ingredient.ingredientID = ID ;
END$$
DELIMITER ;




-- GETTING USER INFORMATION

/**
param: email varchar(500), pass varchar(500)
this procedure will return the associated userID of a user IF THERE IS ONE associated
with the passed in password and email.
**/
DELIMITER $$
DROP PROCEDURE IF EXISTS `getUserID`;
CREATE PROCEDURE `getUserID`(IN emailIn VARCHAR(500), IN pass VARCHAR(500))
BEGIN
	SELECT userID
    FROM   User
    WHERE  User.email = emailIn AND
		   User.password = pass;
END$$
DELIMITER ;


/**
param: emailId
returns: the userID of the user with that email (if there is one)
**/
DROP PROCEDURE IF EXISTS `getUserIDWithEmail`;
DELIMITER $$
CREATE PROCEDURE `getUserIDWithEmail`(IN emailIn VARCHAR(500))
BEGIN
	SELECT userID
    FROM   User
    WHERE  User.email = emailIn;
END$$
DELIMITER ;

##FIXME
/**
param: 
returns:
this procedure
**/
DROP PROCEDURE IF EXISTS `getPassword`;
DELIMITER $$
CREATE PROCEDURE `getPassword`(IN UserId VARCHAR(45))
BEGIN
	SELECT password
    FROM   User
    WHERE  User.userID = UserId;
END$$
DELIMITER ;


/**
param: userID INT
returns: userName VARCHAR(250) first and last name of user
**/
DROP PROCEDURE IF EXISTS `getUserName`;
DELIMITER $$
CREATE PROCEDURE `getUserName`(IN userIdIN INT, OUT userName VARCHAR(250))
BEGIN
	SELECT CONCAT(firstName, " ", lastName)
    FROM User
    WHERE User.userID = userIdIN
    INTO userName;
    END$$
    DELIMITER ;
    
/**
param: userID
this procedure returns all of the ingredients that are restricted for a user. 
Takes into account type and ingredient restrictions.
**/
DROP PROCEDURE IF EXISTS  `getRestrictedIngredients`;
DELIMITER $$
CREATE PROCEDURE `getRestrictedIngredients`(IN userIdIN INT)
BEGIN
	SELECT DISTINCT
    I.ingredientID
	FROM 
		Ingredient as I
	WHERE 
	I.ingredientID in(
		Select i.ingredientID from Ingredient as i
		inner join Ingredient_Type as it on i.ingredientID = it.ingredientID
		inner join Type as t on it.typeID = t.typeID
		where
		t.typeID in
				(
					select
						tr.typeID
					from
						Type_Restriction tr
						inner join User u on tr.userID = u.userID
					where
						u.userID = userIdIN
				)
		);
END $$
DELIMITER ;

/**
param: userID (int)
this procedure returns all of a user's favorited recipes in the form
of their recipeIDs
**/
DROP PROCEDURE IF EXISTS `getUserFavorites`;
DELIMITER $$
CREATE PROCEDURE `getUserFavorites`(IN userIdIN INT)
BEGIN
	SELECT recipeID
    FROM Favorite
    WHERE Favorite.userID = userIdIN;
END$$
DELIMITER ;
    
/**
param: userID INT
this procedure returns all of the recipes
disliked by a user (in the form of ther recipeIDs)
**/
DROP PROCEDURE IF EXISTS `getUserDislikes`;
DELIMITER $$
CREATE PROCEDURE `getUserDislikes`(IN userIdIN INT)
BEGIN
	SELECT recipeID
    FROM Dislike
    WHERE Dislike.userID = userIdIN;
END$$
DELIMITER ;

/**
param: userID (int)
returns: userEmail varchar(25)
this procedure returns a user's email given their userID
**/
DROP PROCEDURE IF EXISTS `getUserEmail`;
DELIMITER $$
CREATE PROCEDURE `getUserEmail`(IN userIdIN INT, OUT userEmail VARCHAR(250))
BEGIN
	SELECT email
    FROM User
    WHERE User.userID = userIdIN
    INTO userEmail;
END$$
DELIMITER ;


-- ADDING/REMOVING USER INFORMATION

/**
param: userID INT, recipeID INT, reasonng LONGTEXT
this procedure creates a new relationship between a user and a recipe in the favorites table.
**/
DROP PROCEDURE IF EXISTS `AddFavorite`;
DELIMITER $$
CREATE PROCEDURE `AddFavorite`(IN userIdIN INT, IN recipeIdIN INT, IN reasoning LONGTEXT)
BEGIN
	INSERT INTO Favorite(userID, recipeID, reason) values(userIdIN, recipeIdIN,reasoning);
END$$
DELIMITER ;


/**
param: userID INT, recipeID INT
this procedure deletes a previously existing relationship between a user and a recipe in the favorites table.
**/
DROP PROCEDURE IF EXISTS `DeleteFavorite`;
DELIMITER $$
CREATE PROCEDURE `DeleteFavorite`(IN userIdIN INT, IN recipeIdIN INT)
BEGIN
	DELETE FROM Favorite AS f
    WHERE f.userID = userIdIN 
    AND   r.recipeID = recipeIdIN;
END$$
DELIMITER ;

/**
param: userID INT, recipeID INT, reasonng LONGTEXT
this procedure creates a new relationship between a user and a recipe in the dislikes table.
**/
DROP PROCEDURE IF EXISTS `AddDislike`;
DELIMITER $$
CREATE PROCEDURE `AddDislike`(IN userIdIN INT, IN recipeIdIN INT, IN reasoning LONGTEXT)
BEGIN
	INSERT INTO Dislike(userID, recipeID, reason) values(userIdIN, recipeIdIN,reasoning);
END$$
DELIMITER ;


/**
param: userID INT, recipeID INT
this procedure deletes a previously existing relationship between a user and a recipe in the Dislike table.
**/
DROP PROCEDURE IF EXISTS `DeleteDislike`;
DELIMITER $$
CREATE PROCEDURE `DeleteDislike`(IN userIdIN INT, IN recipeIdIN INT)
BEGIN
	DELETE FROM Dislike AS d
    WHERE d.userID = userIdIN 
    AND   d.recipeID = recipeIdIN;
END$$
DELIMITER ;


/**
param: userID INT, ingredientID INT
This procedure creates a new user ingredient restriction
**/
DROP PROCEDURE IF EXISTS `AddUserIngredientRestriction`;
DELIMITER $$
CREATE PROCEDURE `AddUserIngredientRestriction`(IN userIdIN INT, IN ingredientIdIN INT)
BEGIN
	INSERT INTO Ingredient_Restriction(userID, ingredientID) values(userIdIN, ingredientIdIN);
END$$
DELIMITER ;

/**
param:userID INT, ingredientID INT
this procedure deletes a previously existing ingredient restriction for a user
**/
DROP PROCEDURE IF EXISTS `DeleteUserIngredientRestriction`;
DELIMITER $$
CREATE PROCEDURE `DeleteUserIngredientRestriction`(IN userIdIN INT, IN ingredientIdIN INT)
BEGIN
	DELETE FROM Ingredient_Restriction
    WHERE userID = userIdIN 
    AND ingredientID = ingredientIdIN;
END$$
DELIMITER ;

/**
param: userID int, typeID INT
this procedure creates a new user type restriction
**/
DROP PROCEDURE IF EXISTS `AddUserTypeRestriction`;
DELIMITER $$
CREATE PROCEDURE `AddUserTypeRestriction`(IN userIdIN INT, IN typeIdIN INT)
BEGIN
	INSERT INTO Type_Restriction(userID, typeID) values(userIdIN, typeIdIN);
END$$
DELIMITER ;


/**
param:userID INT, typeID INT
this procedure deletes a previously existing user type restriction
**/
DROP PROCEDURE IF EXISTS `DeleteUserTypeRestriction`;
DELIMITER $$
CREATE PROCEDURE `DeleteUserTypeRestriction`(IN userIdIN INT, IN typeIdIN INT)
BEGIN
	DELETE FROM Type_Restriction
    WHERE userID = userIdIN
    AND   typeID = typeIdIN;
END$$
DELIMITER ;


/**
param: firstNameIN VARCHAR(100), lastNameIN VARCHAR(100), emailIN VARCHAR(45), phoneIN VARCHAR(45), dateJoinedIN DATE, passwordIN VARCHAR(45)
this procedure adds a new user to the database
**/
DROP PROCEDURE IF EXISTS `AddUser`;
DELIMITER $$
CREATE PROCEDURE `AddUser`(IN firstNameIN VARCHAR(100), IN lastNameIN VARCHAR(100), IN emailIN VARCHAR(45), IN phoneIN VARCHAR(45), IN dateJoinedIN DATE, IN passwordIN VARCHAR(45))
BEGIN
	INSERT INTO User(firstName, lastName, email, phone, dateJoined, password)  values(firstNameIN, lastNameIN, emailIN, phoneIN, dateJoinedIN, passwordIN);
END$$
DELIMITER ;


-- -----------------------------
-- GETTING RECIPE INFORMATION --

/**
param: recipeID INT
this procedure returns the instruction for making a recipe.
**/
DROP PROCEDURE IF EXISTS `getInstructions`;
DELIMITER $$
CREATE PROCEDURE `getInstructions`(IN ID INT)
BEGIN
    SELECT  instruction
    FROM    Recipe
    WHERE   recipeID = ID;
END$$
DELIMITER ;

/**
param:recipeID
this procedure returns the estimated amount of time a recipe takes
**/
DROP PROCEDURE IF EXISTS `getTime`;
DELIMITER $$
CREATE PROCEDURE `getTime`(IN ID INT)
BEGIN
    SELECT  timeEstimate
    FROM    Recipe
    WHERE   recipeID = ID;
END$$
DELIMITER ;


/**
param: time INT
this procedure returns all recipes that take less time than the time passed as an arg.
**/
DROP PROCEDURE IF EXISTS `takesLessTime`;
DELIMITER $$
CREATE PROCEDURE `takesLessTime`(IN time INT)
BEGIN
    SELECT  r.recipeID
    FROM    Recipe r
    WHERE   r.timeEstimate <= time;
END$$
DELIMITER ;


/**
param:recipeID
this procedure returns the spice level of the recipeID passed
**/
DELIMITER $$
DROP PROCEDURE IF EXISTS `getSpice`;
CREATE PROCEDURE `getSpice`(IN ID INT)
BEGIN
    SELECT  spiceLevel
    FROM    Recipe
    WHERE   recipeID = ID;
END$$
DELIMITER ;

/**
param:recipeID INT
this procedure returns the recipe description of the recipeID passed
**/
DELIMITER $$
DROP PROCEDURE IF EXISTS `getDescription`;
CREATE PROCEDURE `getDescription`(IN ID INT)
BEGIN
    SELECT  description
    FROM    Recipe
    WHERE   recipeID = ID;
END$$
DELIMITER ;

/**
param: spice INT
this procedure returns all recipes that have the same spice level as the argument passed
**/
DROP PROCEDURE IF EXISTS `hasSpiceLvL`;
DELIMITER $$
CREATE PROCEDURE `hasSpiceLvL`(IN spice INT)
BEGIN
    SELECT  r.recipeID
    FROM    Recipe r
    WHERE   r.spiceLevel = spice;
END$$
DELIMITER ;


/**
param: recipeID INT
this procedure returns the title of the recipeID passed
**/
DROP PROCEDURE IF EXISTS `getTitle`;
DELIMITER $$
CREATE PROCEDURE `getTitle`(IN ID INT)
BEGIN
    SELECT  r.title
    FROM    Recipe r
    WHERE   r.recipeID = ID;
END$$
DELIMITER ;

/**
param: recipeID INT
this procedure returns the author name of the recipeID passed
**/
DROP PROCEDURE IF EXISTS `getAuthor`;
DELIMITER $$
CREATE PROCEDURE `getAuthor`(IN ID INT)
BEGIN
    SELECT  concat(u.firstName, " ", u.LastName) 
    FROM        Recipe r
    INNER JOIN  User u
    ON          r.authorID = u.userID   
    WHERE       recipeID = ID;
END$$
DELIMITER ;


/**
param: recipeID
this procedure returns the authorID of the recipe passed
**/
DROP PROCEDURE IF EXISTS `getAuthorID`;
DELIMITER $$
CREATE PROCEDURE `getAuthorID`(IN ID INT)
BEGIN
    SELECT  	u.UserID 
    FROM        Recipe r
    INNER JOIN  User u
    ON          r.authorID = u.userID   
    WHERE       recipeID = ID;
END$$
DELIMITER ;


/**
param: recipeID INT
this procedure returns the name of the culture associated with the recipeID passed
**/
DROP PROCEDURE IF EXISTS `getCulture`;
DELIMITER $$
CREATE PROCEDURE `getCulture`(IN ID INT)
BEGIN
    SELECT      C.name
    FROM        Culture C
    INNER JOIN  Recipe_Culture c
    ON          C.idCulture = c.cultureID   
    WHERE       recipeID = ID;
END$$
DELIMITER ;

/**
param: recipeID
this procedure returns the cultureID of the culture associated with the recipeID passed
**/
DROP PROCEDURE IF EXISTS `getCultureID`;
DELIMITER $$
CREATE PROCEDURE `getCultureID`(IN ID INT)
BEGIN
    SELECT      C.idCulture
    FROM        Culture C
    INNER JOIN  Recipe_Culture c
    ON          C.idCulture = c.cultureID   
    WHERE       recipeID = ID;
END$$
DELIMITER ;

/**
param: authorID
this procedure returns all recipes that were written by the authorID passed
**/
DROP PROCEDURE IF EXISTS `writtenBy`;
DELIMITER $$
CREATE PROCEDURE `writtenBy`(IN author INT)
BEGIN 
    SELECT      r.recipeID
    FROM        Recipe r
    WHERE       r.authorID = author;
END$$
DELIMITER ;

/**
param: recipeID
this procedure returns all of the ingredients (as a string) of the recipeID passed
**/
DROP PROCEDURE IF EXISTS `getIngredients`;
DELIMITER $$
CREATE PROCEDURE `getIngredients`(IN ID INT)
BEGIN
    SELECT      CONCAT(ri.quantity, " ", ri.quantityUnit, " ", i.name) as Ingredient
    FROM        Recipe r
    INNER JOIN  Recipe_Ingredient ri
    ON          r.recipeID = ri.recipeID
    INNER JOIN  Ingredient i
    ON          ri.ingredientID = i.ingredientID
    WHERE       ri.recipeID = ID;
END$$
DELIMITER ;

/**
param: recipeID INT
this procedure returns all of the ingredient in a recipe as their IDs.
**/
DROP PROCEDURE IF EXISTS `getIngredientsID`;
DELIMITER $$
CREATE PROCEDURE `getIngredientsID`(IN ID INT)
BEGIN
    SELECT      i.ingredientID
    FROM        Recipe r
    INNER JOIN  Recipe_Ingredient ri
    ON          r.recipeID = ri.recipeID
    INNER JOIN  Ingredient i
    ON          ri.ingredientID = i.ingredientID
    WHERE       ri.recipeID = ID;
END$$
DELIMITER ;

/**
param: ingredientID INT
this procedure returns all recipes (recipeIDs) that contain the ingredient passed as an arg
**/
DROP PROCEDURE IF EXISTS `hasIngredient`;
DELIMITER $$
CREATE PROCEDURE `hasIngredient`(IN ingre INT)
BEGIN   
    SELECT          r.recipeID
    FROM            Recipe as r
    INNER JOIN      Recipe_Ingredient ri
    ON              r.recipeID = ri.recipeID
    WHERE           ri.ingredientID = ingre;
END$$
DELIMITER ;

/**
param: cultureID
this procedure returns all recipeIDs associated with passed cultureID
**/
DROP PROCEDURE IF EXISTS `hasCulture`;
DELIMITER $$
CREATE PROCEDURE `hasCulture`(IN culture INT) 
BEGIN
    SELECT          r.recipeID
    FROM            Recipe as r
    INNER JOIN      Recipe_Culture rc
    ON              r.recipeID = rc.recipeID
    WHERE           rc.cultureID = culture;
END$$
DELIMITER ;



-- ADDING RECIPES / RECIPE INFORMATION

/**
param: title VARCHAR(500), descr LONGTEXT, time INT, spice INT, date DATETIME, calories INT, author INT, instr LONGTEXT
this procedure creates a new recipe in the database
**/
DROP PROCEDURE IF EXISTS `writeRecipe`;
DELIMITER $$
CREATE PROCEDURE `writeRecipe`(IN title VARCHAR(500), IN descr LONGTEXT, IN time INT, IN spice INT, IN date DATETIME, IN calories INT, IN author INT, IN instr LONGTEXT)
BEGIN
    INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values(title, descr, time, spice, date, calories, author, instr);
END$$
DELIMITER ;


/**
param: recipeID INT
this procedure deletes a recipe from the database (and all associated favorites/dislikes)
**/
DROP PROCEDURE IF EXISTS `deleteRecipe`;
DELIMITER $$
CREATE PROCEDURE `deleteRecipe` (IN recipeIdIN INT)
BEGIN
	DELETE FROM Recipe_Culture as rc
    WHERE rc.recipeID = recipeIdIN;
    DELETE FROM Recipe_Ingredient as ri
    WHERE ri.recipeID = recipeIdIN;
    DELETE FROM Dislike as d
    WHERE d.recipeID = recipeIdIN;
    DELETE FROM Favorite as f
    WHERE f.recipeID = recipeIdIN;
    DELETE FROM Recipe as r
    WHERE r.recipeID = recipeIdIN;
END$$
DELIMITER ;

/**
params: recipeID INT, ingredientID INT, quantity FLOAT, quantityType VARCHAR(45), note VARCHAR(300)
this procedure creates a relationship between an ingredient and a recipe.
**/
DROP PROCEDURE IF EXISTS `addRecipe_Ingredient`;
DELIMITER $$
CREATE PROCEDURE `addRecipe_Ingredient`(IN recipe INT, IN ingre INT, IN quant FLOAT, IN quantType VARCHAR(45), IN note VARCHAR(300))
BEGIN
    INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(recipe, ingre, quant, quantType, note);
END$$
DELIMITER ;


/**
param:recipeID INT, cultureID INT
this procedure associates a recipe with a culture.
**/
DROP PROCEDURE IF EXISTS `setCulture`;
DELIMITER $$
CREATE PROCEDURE `setCulture`(IN recipe INT, IN culture INT)
BEGIN
    INSERT INTO Recipe_Culture(recipeID, cultureID) values(recipe, culture);
END$$
DELIMITER ;


-- -----------------------------
-- GET INGREDIENT INFORMATION --

/**
param: ingredientID INT
this procedure returns the name of an ingredient given the ingredientID
**/
DROP PROCEDURE IF EXISTS `getIngredientName`;
DELIMITER $$
CREATE PROCEDURE `getIngredientName`(IN ingreID INT)
BEGIN
	SELECT name
    FROM Ingredient
    WHERE ingredientID = ingreID;
END$$
DELIMITER ;

/**
param: ingredientID INT
this procedure returns all recipes that do not use the passed ingredientID
**/
DROP PROCEDURE IF EXISTS `doesNotHaveIngredient`;
DELIMITER $$
CREATE PROCEDURE `doesNotHaveIngredient`(IN ingreID INT)
BEGIN
    SELECT DISTINCT     r.recipeID
    FROM                Recipe as r
    WHERE
        r.recipeID NOT IN
        (
            SELECT DISTINCT recipeID
            FROM            Recipe_Ingredient ri
            WHERE           ri.ingredientID = ingreID
        );
END $$
DELIMITER ;

/**
param: None
this procedure returns the number of recipes in the database
**/
DROP PROCEDURE IF EXISTS `countRecipes`;
DELIMITER $$
CREATE PROCEDURE `countRecipes`()
BEGIN
	SELECT COUNT(recipeID)
    FROM Recipe;
END $$
DELIMITER ;

/**
param: None
this procedure returns all of the recipes in the database (in the form of recipeIDs)
**/
DROP PROCEDURE IF EXISTS `getAllRecipes`;
DELIMITER $$
CREATE PROCEDURE `getAllRecipes`()
BEGIN
	SELECT recipeID
    FROM Recipe;
END $$
DELIMITER ;

/**
searchForRecipe procedure is a procedure created that allows searching for a recipe given the type of food restrictions, maximum spice level, maximum time, authorId, cultureId,
an ingredient restriction, and an ingredient inlcusion. Any combination of these values can be data-valued, or NULL. (for use with python-connector pass the argument as None)
**/
DROP PROCEDURE IF EXISTS `searchForRecipe`;
DELIMITER $$
CREATE PROCEDURE `searchForRecipe`(IN typeIdVar INT, IN spiceLvlVar INT, IN timeVar INT, IN authorIdVar INT, IN cultureIdVar INT, IN ingreRestrictionVar INT, IN ingreInclusionVar INT)
BEGIN
	SELECT
    r.recipeID
	FROM
		Recipe AS r
	WHERE 
    CASE 
        WHEN typeIdVar IS NULL THEN
			r.recipeID in (
			select r.recipeID from Recipe as r
			)
        ELSE r.recipeID NOT IN -- handles TYPE
			( SELECT r.recipeID 
			  FROM Recipe AS r
			  INNER JOIN Recipe_Ingredient ri ON r.recipeID = ri.recipeID
			  WHERE ri.ingredientID IN
				(
					SELECT ingredientID
					FROM Ingredient_Type it
					WHERE it.typeID = typeIdVar
				)
			)
		END
	AND CASE
		WHEN ingreRestrictionVar IS NULL THEN -- if no recipes are restricted
			r.recipeID in (
			select r.recipeID from Recipe as r
			)
		ELSE 
			r.recipeID not in -- handles specific ingredient RESTRICTION
			( select r.recipeID
			from Recipe as r
			inner join Recipe_Ingredient ri on r.recipeID = ri.recipeID
			where ri.ingredientID = ingreRestrictionVar
			)
		END
			
	and CASE
		WHEN ingreInclusionVar IS NULL THEN -- handles null ingredient inclusion
			r.recipeID in (
			select r.recipeID from Recipe as r
			)
		ELSE
			r.recipeID in -- handles specific ingredient INCLUSION
			( select r.recipeID
			from Recipe as r
			inner join Recipe_Ingredient ri on r.recipeID = ri.recipeID
			where ri.ingredientID = ingreInclusionVar
			)
		END
        
	 and CASE 
		WHEN cultureIdVar IS NULL THEN -- handles null culture (no chosen culture)
			r.recipeID in (
			select r.recipeID from Recipe as r
			)
		ELSE
			r.recipeID in -- handles culture
			( select r.recipeID
			from Recipe as r
			inner join Recipe_Culture rc on r.recipeID = rc.recipeID
			where rc.cultureID = cultureIdVar
			)
		END

	and CASE -- handles author being null
		WHEN authorIdVar IS NULL THEN
			r.recipeID in (
			select r.recipeID from Recipe as r
			)
		ELSE r.authorID = authorIdVar -- handles author
        END
		
	and CASE
		WHEN spiceLvlVar IS NULL THEN -- handles null spice
			r.recipeID in (
			select r.recipeID from Recipe as r
			)
		ELSE r.spiceLevel <= spiceLvlVar -- handles spice
        END
		
	and CASE
		WHEN timeVar IS NULL THEN
		r.recipeID in (
			select r.recipeID from Recipe as r
			)
		ELSE r.timeEstimate <= timeVar-- handles timeEstimate
        END;
END $$
DELIMITER ;













