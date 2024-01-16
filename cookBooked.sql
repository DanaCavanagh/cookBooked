-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Schema cookBooked
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema cookBooked
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `cookBooked`;
CREATE SCHEMA IF NOT EXISTS `cookBooked` DEFAULT CHARACTER SET utf8mb4 ;
USE `cookBooked` ;

-- -----------------------------------------------------
-- Table `cookBooked`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`User` (
  `userID` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(100) NOT NULL,
  `lastName` VARCHAR(100) NULL,
  `email` VARCHAR(45) NOT NULL UNIQUE,
  `phone` VARCHAR(45) NULL,
  `dateJoined` DATE NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`userID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Ingredient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Ingredient` (
  `ingredientID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ingredientID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Ingredient_Restriction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Ingredient_Restriction` (
  `userID` INT NOT NULL,
  `ingredientID` INT NOT NULL,
  PRIMARY KEY (`userID`, `ingredientID`),
  INDEX `fk_Dietary Restriction_2_idx` (`ingredientID` ASC) VISIBLE,
  CONSTRAINT `fk_Dietary Restriction_1`
    FOREIGN KEY (`userID`)
    REFERENCES `cookBooked`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Dietary Restriction_2`
    FOREIGN KEY (`ingredientID`)
    REFERENCES `cookBooked`.`Ingredient` (`ingredientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Type` (
  `typeID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(300) NOT NULL,
  `description` LONGTEXT NOT NULL,
  PRIMARY KEY (`typeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Ingredient_Type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Ingredient_Type` (
  `ingredientID` INT NOT NULL,
  `typeID` INT NOT NULL,
  PRIMARY KEY (`ingredientID`, `typeID`),
  INDEX `fk_Ingredient_Type_2_idx` (`typeID` ASC) VISIBLE,
  CONSTRAINT `fk_Ingredient_Type_1`
    FOREIGN KEY (`ingredientID`)
    REFERENCES `cookBooked`.`Ingredient` (`ingredientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ingredient_Type_2`
    FOREIGN KEY (`typeID`)
    REFERENCES `cookBooked`.`Type` (`typeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Recipe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Recipe` (
  `recipeID` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(500) NOT NULL,
  `description` LONGTEXT NOT NULL,
  `timeEstimate` INT NULL,
  `spiceLevel` INT NULL,
  `datePosted` DATETIME NOT NULL,
  `caloriesPerServe` INT NULL,
  `authorID` INT NOT NULL,
  `instruction` LONGTEXT NOT NULL,
  PRIMARY KEY (`recipeID`),
  INDEX `fk_Recipe_1_idx` (`authorID` ASC) VISIBLE,
  CONSTRAINT `fk_Recipe_1`
    FOREIGN KEY (`authorID`)
    REFERENCES `cookBooked`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Recipe_Ingredient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Recipe_Ingredient` (
  `recipeID` INT NOT NULL,
  `ingredientID` INT NOT NULL,
  `quantity` FLOAT NOT NULL,
  `quantityUnit` VARCHAR(45) NOT NULL,
  `notes` VARCHAR(300) NULL,
  PRIMARY KEY (`recipeID`, `ingredientID`),
  INDEX `fk_Recipe_Ingredient_1_idx` (`ingredientID` ASC) VISIBLE,
  CONSTRAINT `fk_Recipe_Ingredient_1`
    FOREIGN KEY (`ingredientID`)
    REFERENCES `cookBooked`.`Ingredient` (`ingredientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Recipe_Ingredient_2`
    FOREIGN KEY (`recipeID`)
    REFERENCES `cookBooked`.`Recipe` (`recipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Dislike`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Dislike` (
  `userID` INT NOT NULL,
  `recipeID` INT NOT NULL,
  `reason` LONGTEXT NULL,
  PRIMARY KEY (`userID`, `recipeID`),
  INDEX `fk_Dislike_1_idx` (`recipeID` ASC) VISIBLE,
  CONSTRAINT `fk_Dislike_1`
    FOREIGN KEY (`recipeID`)
    REFERENCES `cookBooked`.`Recipe` (`recipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Dislike_2`
    FOREIGN KEY (`userID`)
    REFERENCES `cookBooked`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Favorite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Favorite` (
  `userID` INT NOT NULL,
  `recipeID` INT NOT NULL,
  `reason` LONGTEXT NULL,
  PRIMARY KEY (`userID`, `recipeID`),
  INDEX `fk_Favorite_1_idx` (`recipeID` ASC) VISIBLE,
  CONSTRAINT `fk_Favorite_1`
    FOREIGN KEY (`recipeID`)
    REFERENCES `cookBooked`.`Recipe` (`recipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Favorite_2`
    FOREIGN KEY (`userID`)
    REFERENCES `cookBooked`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Culture`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Culture` (
  `idCulture` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NOT NULL,
  `region` LONGTEXT NOT NULL,
  PRIMARY KEY (`idCulture`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Recipe_Culture`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Recipe_Culture` (
  `recipeID` INT NOT NULL,
  `cultureID` INT NOT NULL,
  PRIMARY KEY (`recipeID`, `cultureID`),
  INDEX `fk_Recipe_Culture_1_idx` (`cultureID` ASC) VISIBLE,
  CONSTRAINT `fk_Recipe_Culture_1`
    FOREIGN KEY (`cultureID`)
    REFERENCES `cookBooked`.`Culture` (`idCulture`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Recipe_Culture_2`
    FOREIGN KEY (`recipeID`)
    REFERENCES `cookBooked`.`Recipe` (`recipeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cookBooked`.`Type_Restriction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cookBooked`.`Type_Restriction` (
  `typeID` INT NOT NULL,
  `userID` INT NOT NULL,
  PRIMARY KEY (`typeID`, `userID`),
  INDEX `fk_Type Restriction_2_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_Type Restriction_1`
    FOREIGN KEY (`typeID`)
    REFERENCES `cookBooked`.`Type` (`typeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Type Restriction_2`
    FOREIGN KEY (`userID`)
    REFERENCES `cookBooked`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



INSERT INTO Type(name,description) VALUES
('poultry', 'domestic fowl, such as chickens, turkeys, ducks, and geese.'), -- 1
('animal product', 'any material derived from the body of a non-human animal'), -- 2
('dairy','containing or made from milk.'), -- 3
('treenut','nuts that grow on trees'), -- 4
('soy','protein derived from soybeans, used as a replacement for animal protein in foods and fodder'), -- 5
('meat','the flesh of an animal (especially a mammal) as food. THIS CATEGORY DOES NOT INCLUDE SEAFOOD'), -- 6
('pork','the flesh of a pig used as food, especially when uncured.'), -- 7
('fruit','the sweet and fleshy product of a tree or other plant that contains seed and can be eaten as food.'), -- 8
('vegetable','a plant or part of a plant used as food, such as a cabbage, potato, carrot, or bean.'), -- 9
('grain', 'wheat or any other cultivated cereal crop used as food.'), -- 10
('fat/oil', 'Oils are fats that are liquid at room temperature, like vegetable oils used in cooking. They come from many different plants and from fish.'), -- 11
('legume','a leguminous plant (member of the pea family), especially one grown as a crop.'), -- 12
('baked good','foods made from dough or batter and cooked by baking'), -- 13
('fungi','Edible fungi means fruit bodies of a specific plant group'), -- 14
('seed', 'a flowering plants unit of reproduction, capable of developing into another such plant.'), -- 15
('seafood', 'shellfish and sea fish, served as food'), -- 16
('shellfish', 'an aquatic shelled mollusk (e.g. an oyster or cockle) or crustacean (e.g. a crab or shrimp), especially one that is edible.'), -- 17
('condiment', 'a substance such as salt or ketchup that is used to add flavor to food.'), -- 18
('alcohol', 'a colorless volatile flammable liquid that is produced by the natural fermentation of sugars and is the intoxicating constituent of wine, beer, spirits, and other drinks, and is also used as an industrial solvent and as fuel.'), -- 19
('spice','an aromatic or pungent vegetable substance used to flavor food, e.g. cloves, pepper, or cumin.'), -- 20
('herb','any plant with leaves, seeds, or flowers used for flavoring, food, medicine, or perfume.'), -- 21
('nut', 'a fruit consisting of a hard or tough shell around an edible kernel'), -- 22
('plant-based product', 'a product that is plant derived, but is in a different form than its fresh plant form'), -- 23
('water','H2O -- self explanatory, I would hope.');

INSERT INTO  `Ingredient`(`name`) VALUES
('green onion'), -- 1
('yellow onion'), -- 2
('red onion'), -- 3
('purple onion'), -- 4
('garlic'), -- 5
('milk'), -- 6
('cream'), -- 7
('sour cream'), -- 8
('olive oil'), -- 9
('chicken breast'), -- 10
('carrot'), -- 11
('celery'), -- 12
('chicken stock'), -- 13
('diced tomatoes'), -- 14
('cannellini beans'), -- 15
('kidney beans'), -- 16
('tomato paste'), -- 17
('zucchini'), -- 18
('green beans'), -- 19
('italian seasoning'), -- 20
('ditalini pasta'),    -- 21
('black pepper'),      -- 22
('salt'),              -- 23
('parmesan cheese'), -- 24
('parsley'),   -- 25
('cranberry'), -- 26
('sugar'), -- 27
('orange juice'), -- 28
('brussel sprouts'), -- 29
('bacon'), -- 30
('maple syrup'), -- 31 ---
('butter'), -- 32
('mushrooms'), -- 33
('bread'), -- 34
('sage'), -- 35
('poultry seasoning'), -- 36
('thyme'), -- 37
('marjoram'), -- 38
('egg'), -- 39
('water'), -- 40
('macaroni and cheese mix'), -- 41
('margarine'), -- 42
('sharp cheddar cheese'), -- 43
('jalapeno'), -- 44
('garlic powder'), -- 45
('onion powder'), -- 46
('paprika'), -- 47
('precooked chicken meatballs'), -- 48
('panko bread crumbs'), -- 49
('barbeque sauce'), -- 50
('lemon'), -- 51
('rosemary'), -- 52
('oregano'), -- 53
('chicken'), -- 54
('shrimp'), -- 55
('cayenne pepper'), -- 56
('avocado oil'), -- 57
('poblano pepper'), -- 58
('chili powder'), -- 59
('cumin'), -- 60
('chipotle pepper'), -- 61
('lobster bisque soup'), -- 62
('cilantro'), -- 63
('monterey jack cheese'), -- 64
('cheddar cheese'), -- 65
('radish'), -- 66
('hot sauce'), -- 67
('lime'), -- 68
('mayonnaise'), -- 69
('corn'), -- 70
('cotija cheese'), -- 71
('scallion'), -- 72
('extra firm tofu'), -- 73
('green cabbage'), -- 74
('red cabbage'), -- 75
('sesame oil'), -- 76
('creamy peanut butter'), -- 77
('agave nectar'), -- 78
('soy sauce'), -- 79
('red pepper flakes'), -- 80
('coconut oil'), -- 81
('red curry paste'), -- 82
('japanese eggplant'), -- 83
('coconut milk'); -- 84

INSERT INTO  `Ingredient_Type`(`ingredientID`, `typeID`) VALUES
-- green onion 1
(1, 9),
-- yellow onion 2
(2, 9),
-- red onion 3
(3, 9),
-- purple onion 4
(4, 9),
-- garlic 5
(5, 9),
-- milk 6
(6, 3),
(6, 2),
-- cream 7
(7,3),
(7,2),
-- sour cream 8
(8,3),
(8,2),
-- olive oil 9
(9,11),
-- chicken breast 10
(10,1),
(10,2),
(10,6),
-- carrot 11
(11,9),
-- celery 12
(12,9),
-- chicken stock 13
(13,1),
(13,2),
-- diced tomatoes 14
(14,9),
-- cannellinni beans 15
(15,12),
-- kidney beans 16
(16,12),
-- tomato paste 17
(17,23),
-- zucchini 18
(18,8),
-- green beans 19
(19,9),
-- italian seasoning 20
(20,21),
(20,20),
-- ditalini pasta 21
(21,10),
(21,13),
-- black pepper 22
(22,20),
-- salt 23
(23,20),
-- parmesan cheese 24
(24, 2),
(24, 3),
-- parsley 25
(25, 21),
-- cranberry 26
(26, 8),
-- sugar 27
(27, 20),
-- orange juice 28
(28, 23),
-- brussel sprout 29
(29, 9),
-- bacon 30
(30, 2),
(30,6),
(30,7),
-- maple syrup 31
(31, 18),
-- butter 32
(32, 2),
(32, 3),
-- mushrooms 33
(33, 14),
-- bread 34
(34, 13),
(34, 10),
-- sage 35 
(35, 21),
-- pultry seasoning 36
(36,20),
(36,21),
-- thyme 37
(37, 21),
-- marjoram 38
(38, 21),
-- egg 39
(39, 2),
-- water 40
(40, 24),
-- macaroni and cheese mix 41
(41, 3),
(41, 2),
(41, 10),
(41, 13),
-- margarine 42
(42, 11),
-- sharp cheddar cheese 43
(43, 2),
(43, 3),
-- jalapeno 44
(44, 9),
-- garlic powder 45
(45, 20),
-- onion powder 46
(46,20),
-- paprika 47
(47,20),
-- precooked chicken meatballs 48
(48,1),
(48,2),
(48,6),
-- panko bread crumbs 49
(49, 10),
(48, 13),
-- barbeque sauce 50
(50, 18),
-- lemon 51
(51, 8),
-- rosemary 52
(52,21),
-- oregano 53
(53, 21),
-- chicken 54
(54, 1),
(54, 2),
(54, 6),
-- shrimp 55
(55, 2),
(55, 16),
(55, 17),
-- cayenne pepper 56
(56, 20),
-- avocado oil 57
(57, 11),
-- poblano pepper 58
(58, 9),
-- chili powder 59
(59, 20),
-- cumin 60
(60, 20),
-- chipotle pepper 61
(61, 9),
-- lobster bisque soup 62
(62, 2),
(62, 16),
(62, 17),
-- cilantro 63
(63, 21),
-- monterey jack cheese 64
(64, 2),
(64, 3),
-- cheddar cheese 65
(65, 2),
(65,3),
-- radish 66
(66, 9),
-- hot sauce 67
(67, 18),
-- lime 68
(68, 8),
-- mayonnaise 69
(69, 18),
-- corn 70
(70, 9),
-- cotija cheese 71
(71, 2),
(71, 3),
-- scallion 72
(72, 9),
-- extra firm tofu 73
(73, 23),
(73, 5),
-- green cabbage 74
(74, 9),
-- red cabbage 75
(75, 9),
-- sesame oil 76
(76, 11),
(76, 15),
-- creamy peanut butter 77
(77, 4),
(77, 22),
-- agave nectar 78
(78, 23),
(78, 18),
-- soy sauce 79
(79, 5),
(79, 18),
-- red pepper flakes 80
(80, 20),
-- coconut oil 81
(81, 11),
(81, 22),
(81, 4),
-- red curry paste 82
(82, 23),
-- japanese eggplant 83
(83, 9),
-- coconut milk 84
(84, 4),
(84, 22),
(84, 3);







-- user inserts
-- 1
INSERT INTO User(firstName, lastName, email, phone, dateJoined, password)  values("Connor", "George", "thisIsConnorsEmail@email.com", "(111) 111-1111", "2002-02-14", "password");
-- 2
INSERT INTO User(firstName, lastName, email, phone, dateJoined, password) values("Ken", "Whitener", "thisIsKensEmail@email.com", "(222) 222-2222", "1950-08-13", "root");
-- 3
INSERT INTO User(firstName, lastName, email, phone, dateJoined, password) values("Dana", "Cavanagh", "thisIsDanasEmail@email.com", "(333) 333-3333", "2006-10-21", "danadidn'twritethis");
-- 4
INSERT INTO User(firstName, lastName, email, phone, dateJoined, password) values("Hugo", "Hammond", "thisIsHugosEmail@email.com", "(444) 444-4444", "2002-02-14", "hugostrange!!");
-- 5
INSERT INTO User(firstName, lastName, email, phone, dateJoined, password) values("Zane", "Berry", "thisIsZanesEmail@email.com", "(555) 555-5555", "2003-03-15", "zanyzane123");
-- 6
INSERT INTO User(firstName, lastName, email, phone, dateJoined, password) values("Mason", "Austin", "thisIsMasonsEmail@email.com", "(666) 666-6666", "2004-04-16", "stonemasonXD");
-- 7
INSERT INTO User(firstName, lastName, email, phone, dateJoined, password) values("Christina", "Meyers", "thisIsChristinasEmail@email.com", "(777) 777-7777", "2005-05-17", "jesuschristina");
-- 8
INSERT INTO User(firstName, lastName, email, phone, dateJoined, password) values("Alysha", "Rice", "thisIsAlyshasEmail@email.com", "(888) 888-8888", "2006-06-18", "Alyshacooker__");
-- 9
INSERT INTO User(firstName, lastName, email, phone, dateJoined, password) values("Kieran", "Lam", "thisIsKieransEmail@email.com", "(999) 999-9999", "2007-07-19", "LaMcHoP");
-- 10
INSERT INTO User(firstName, lastName, email, phone, dateJoined, password) values("James", "Pham", "thisIsJamessEmail@email.com", "(123) 456-7789", "2008-08-20", "litpham420");


-- culture inserts
-- 1
INSERT INTO Culture(name, description, region) values("Greek", "Greek cuisine mainly uses fresh local ingredients such as Mediterranean vegetables, olive oil, Greek yogurt, Greek honey, feta cheese, various types of fish and meat, and muesli", "Greece");
-- 2
INSERT INTO Culture(name, description, region) values("Mexican", "Mexican food has a reputation for being very spicy, but it has a wide range of flavors and while many spices are used for cooking, not all are spicy", "Mexico");
-- 3
INSERT INTO Culture(name, description, region) values("American", "Highlights of American cuisine include milkshakes, barbecue, and a wide range of fried foods", "America");
-- 4
INSERT INTO Culture(name, description, region) values("British", "unfussy dishes made with quality local ingredients, matched with simple sauces to accentuate flavour, rather than disguise it", "Britain");
-- 5
INSERT INTO Culture(name, description, region) values("Korean", "Korean cuisine is largely based on rice, vegetables, seafood and meats. Dairy is largely absent from the traditional Korean diet", "South Korea");
-- 6
INSERT INTO Culture(name, description, region) values("Moonese", "Moonese cuisine lacks meat beacuse there are no animals on the moon", "Moon");
-- 7
INSERT INTO Culture(name, description, region) values("Russian", "Staple Russian food features lots of fish, mushrooms, and berries", "Russia");
-- 8
INSERT INTO Culture(name, description, region) values("Middle Eastern", "Characterized by fragrant and copious spices, nuts, olive oil, and creamy elements. Mutton, lamb, and goat are traditional meats", "Middle East");
-- 9
INSERT INTO Culture(name, description, region) values("French", "Wine, cheese, olive oil, and seasonal vegetables are just a few staples", "France");
-- 10
INSERT INTO Culture(name, description, region) values("Thai", "Sour, sweet, salty, bitter and spicy flavours work together to make each dish come alive", "Thailand");

-- reipce inserts
-- 1
INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values("Chicken Minestrone Soup", "Take a classic minestrone soup full of fresh, wholesome vegetables, and add an additional layer of flavor with tender, juicy chicken", 55, 0, "2023-02-16", 260, 4, 
"Heat 2 tablespoons olive oil in a large pot over medium heat. Add chicken to pot, and sauté just until lightly browned, about 3 minutes. Remove chicken from pot; set aside.
Heat remaining 2 tablespoons olive oil in the pot; add onions and cook until translucent, about 3 minutes. Stir in garlic; cook until fragrant, about 30 seconds. Add carrots and celery; cook for 5 minutes, stirring occasionally.
Reduce heat to medium-low; stir in chicken stock, diced tomatoes, cannellini beans, kidney beans, tomato paste, zucchini, green beans, Italian seasoning. Simmer, covered, for 15 minutes.
Stir in chicken and ditalini pasta, and cook until pasta is tender yet firm to the bite, about 8 minutes. Season to taste with salt and black pepper. If soup is too thick, add a little water or stock. Garnish each bowl with Parmesan and parsley" );
-- 2
INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values("Cranberry Sauce", "This cranberry sauce recipe uses fresh cranberries, sugar, and orange juice to make a Thanksgiving classic", 20, 0, "2023-09-26", 95, 5,
"Dissolve sugar in the orange juice in a medium saucepan over medium heat.
Stir in the cranberries and cook until they start to pop, about 10 minutes.
Remove from heat and place sauce in a bowl. It will thicken as it cools.");
-- 3
INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values("Maple Roasted Brussle Sprouts with Bacon", "Brussels sprouts with bacon are roasted in a mixture of maple syrup and olive oil", 30, 0, "2023-09-14", 169, 9,
"Preheat the oven to 400 degrees F (200 degrees C). Line a rimmed baking sheet with aluminum foil. 
Trim ends off Brussels sprouts and cut any large ones in half. Transfer to a large bowl. 
Add bacon, salt, and pepper to the Brussels spouts. Drizzle olive oil and maple syrup over top and toss until sprouts are well coated. 
Transfer to the prepared baking sheet and spread in a single layer. 
Roast in the preheated oven until bacon is crispy and Brussels sprouts are caramelized, 20 to 30 minutes, stirring halfway through.");
-- 4
INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values("Slow Cooker Stuffing", "This crockpot stuffing is an easy way to make extra stuffing for a large crowd — and it frees up stove space because it cooks in a slow cooker. This recipe is designed for use in a standard 4-quart slow cooker and is very tasty and moist", 315, 0, "2022-11-10", 197, 3,
" Melt butter in a skillet over medium heat. Cook and stir onion, celery, mushroom, and parsley in butter until slightly softened, 5 to 8 minutes.
Place bread cubes in a very large mixing bowl. Spoon cooked vegetables over bread cubes. Season with salt, sage, poultry seasoning, thyme, marjoram, and pepper. Pour in enough broth to moisten, then mix in eggs. Transfer mixture to a slow cooker.
Cover and cook on High for 45 minutes, then reduce heat to Low and cook for 4 to 8 hours.");
-- 5
INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values("Baked Mac'n'Cheese with Chicken Meatballs", "Make dinner fun with this easy meal using boxed mac and cheese with added bold flavors and pre-cooked chicken meatballs. Top with your Favorite barbeque sauce and serve", 45, 1, "2023-08-09", 617, 1,
"Bring water to a boil in a saucepan. Add macaroni and cook until tender, 7 to 8 minutes; drain. Stir in margarine, milk, and cheese sauce packet. Set aside to cool slightly. 
Preheat the oven to 400 degrees F (200 degrees C). Grease a 9-inch baking dish. 
Stir together prepared mac and cheese, Cheddar cheese, onions, jalapeno, egg, garlic powder, onion powder, and paprika until well combined. Stir in meatballs. Pour macaroni mixture into the prepared dish. Top with bread crumbs. 
Bake in the preheated oven until golden brown, about 20 minutes. Top with barbeque sauce and serve.");
-- 6
INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values("Greek Chicken", "This Greek chicken recipe is great for a light summer meal. I serve it with sliced tomatoes, feta cheese, and garlic bread.", 480, 0, "2023-07-20", 412, 1,
" Mix olive oil, lemon juice, garlic, rosemary, thyme, and oregano in a glass dish. Place chicken pieces in the mixture; cover and marinate in the refrigerator, 8 hours to overnight.
Preheat an outdoor grill for high heat and lightly oil the grate.
Place chicken on the grill, and discard the marinade. Cook until chicken is no longer pink at the bone and the juices run clear, about 15 minutes per side (smaller pieces will not take as long). An instant-read thermometer inserted near the bone should read 165 degrees F (74 degrees C).");
-- 7
INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values("The Best Easy Shrimp Enchiladas", "I'm calling these the best easy shrimp enchiladas, and they are, without a doubt, the best shrimp enchiladas you will ever taste, thanks to my secret ingredient, canned lobster bisque. They are rich, meaty, and delicious, have a deeper flavor than most lighter shrimp enchiladas, and you don't have to make the creamy enchilada sauce from scratch.", 75, 4, "2023-11-15", 2874, 1,
"Preheat the oven to 450 degrees F (230 degrees C). Season shrimp with salt and cayenne in a bowl and toss with tongs to evenly coat. 
Add 1 tablespoon of avocado oil to a skillet, and set on medium-high heat. Place shrimp, without crowding, in a single layer in the skillet; sear for 30 to 60 seconds per side, then transfer to a bowl. You will have to work in batches. Place seared shrimp in the refrigerator. 
Add peppers, onions, and a large pinch of salt to the skillet. Reduce heat to medium, and cook, stirring up the brown bits from the bottom of the pan, until onions begin to turn translucent, 3 to 5 minutes. 
Season with chili powder, smoked paprika, cumin, black pepper, chipotle pepper, and garlic; sauté for 1 to 2 minutes more. Remove 8 rounded tablespoons of the mixture to a bowl and set aside. 
Pour water into the pan and stir to deglaze the bottom. Stir in lobster bisque, plus a few tablespoons of water used to rinse the cans. Add tomato paste and raise heat to medium-high; stir until well combined. Bring sauce to a simmer, reduce heat to medium, and simmer for 5 to 10 minutes, stirring occasionally. 
Meanwhile, remove shrimp from the refrigerator, and pour any accumulated juices from the shrimp into the sauce. Turn off heat, stir in cilantro, and season with salt and black pepper to taste. 
Transfer half the sauce into the bottom of a large (15x10-inch) baking dish.
Brush each tortilla on both sides with avocado oil. Toss Monterrey Jack and Cheddar cheese together in a bowl. 
Top each tortilla with 1/4 cup cheese mixture, followed by 4 shrimp. Top with 1 spoon of reserved veggie mixture. Add 2 tablespoons cheese mixture on top and roll up tortilla, finishing with seam on bottom. 
Place 8 rolled enchiladas into the baking dish, seam on bottom, and top with remaining sauce. Sprinkle over remaining cheese, or more if desired. 
Bake in the preheated oven until the top starts to brown, and the sauce is bubbly, 20 to 25 minutes. Let enchiladas rest for about 10 minutes before serving. While resting, garnish with thinly sliced jalapenos and radishes. 
Serve with extra sauce from the bottom of the dish spooned over. Garnish with additional sliced jalapeno, radish, and chopped cilantro, and serve with sour cream, hot sauce, and fresh lime wedges.");
-- 8
INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values("Tofu and Summer Vegetable Curry", "This quick vegetarian curry is a great way to use a CSA’s bounty of eggplant and summer squash. Feel free to change that lineup depending on your haul. You can eat the curry as is, or ladle it over cooked noodles or rice to add some heft.", 20, 3, "2019-08-13", NULL, 2,
"Heat 2 Tbsp. oil in a large skillet, preferably nonstick, over medium-high. Add tofu in a single layer and cook, turning over once, until cooked sides are golden brown, about 4 minutes. Transfer to paper towels to drain. Season with kosher salt.
Heat remaining 2 Tbsp. oil in a large pot or high-sided skillet over medium-high. Add onions and a generous pinch of salt and stir to coat. Cook, stirring often, until softened, about 4 minutes. Stir in curry paste and cook, stirring often, until darkened in color, about 2 minutes. Add zucchini, eggplant, and green beans and cook, tossing to coat, until vegetables are softened and starting to brown in spots, 5–7 minutes. Pour in coconut milk and ½ cup water and bring to a simmer.
Add tofu to pot and stir gently to combine. Cook until warmed through, about 3 minutes. Season with more salt if needed.
Divide curry among bowls and add a generous squeeze of lime juice to each. Top with cilantro and peanuts.");
-- 9
INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values("Elote Salad", "A nice way to have elote without having to eat it straight off the husk", 95, 3, "2020-02-19", 257, 6,
" Soak corn in cold water for at least 1 hour.
Mix mayonnaise, lime juice, hot sauce, chile powder, and paprika together in a bowl. Refrigerate chile-lime mayonnaise.
Preheat an outdoor grill for medium heat and lightly oil the grate. Drain corn and grill away from the heat source, 15 to 20 minutes. Let cool until easily handled. Shuck corn and return to the grill; cook over the heat source until lightly charred, 3 to 5 minutes. Remove and let cool.
Cut kernels off the cob. Combine corn kernels, Cotija cheese, cilantro, and scallions in a large bowl. Fold in chile-lime mayonnaise.");
-- 10
INSERT INTO Recipe(title, description, timeEstimate, spiceLevel, datePosted, caloriesPerServe, authorID, instruction) values("Crispy Tofu Slabs with Peanut Sauce and Cabbage Slaw", "Crispy golden tofu (that requires no pressing!) gets drizzled with a creamy and indulgent peanut sauce, and paired alongside a refreshing, citrusy cabbage-carrot slaw", 20, 2, "2020-07-26", NULL, 2,
"Pat dry the excess water from the block of tofu. Slice the tofu widthwise into ⅓ to ½-inch thick slices (about 10 slabs on a 14-ounce block). Dab with paper towels to get rid of some excess water.
Heat the 2 tablespoons of avocado oil in a large nonstick frying pan over medium-high heat. Once the oil is hot, add the tofu slices. Cook for 6 to 8 minutes, gently moving them around the pan as needed to coat evenly in the oil, or until the bottom is golden browned. Stand back to avoid oil sputter. Using a spatula, flip the tofu and cook for 4 to 6 minutes on the other side.
Meanwhile, make the slaw. Shred the cabbage and carrots (using a mandoline, box grater, or food processor shredding disc). Transfer the cabbage and carrots to a large bowl, and add the cilantro. In a small bowl, whisk together 1Tbs olive oil, 1Tbs sesame oil, 2Tbs lime juice, ½ teaspoon sea salt, and black pepper to taste. Pour the vinaigrette on top of the slaw and toss well to coat. Add a final squeeze of lime juice or a sprinkle of salt and pepper, if needed.
Meanwhile, make the peanut sauce. Add the peanut butter to a bowl, along with the agave, 1Tbs lime juice, soy sauce, 1 teaspoon of sesame oil, and red pepper flakes. Whisk well to combine until smooth. Taste, adding the additional teaspoon of sesame oil, if desired. Stream in the water, a tablespoon at a time, and whisk until the sauce is pourable but still thick.");

-- Dislike inserts
-- 1
INSERT INTO Dislike(userID, recipeID, reason) values(10, 1, "Could really use cranberry sauce");
-- 2
INSERT INTO Dislike(userID, recipeID, reason) values(10, 2, "Where is the tofu?");
-- 3
INSERT INTO Dislike(userID, recipeID, reason) values(10, 3, "They should make this in a slow cooker");
-- 4
INSERT INTO Dislike(userID, recipeID, reason) values(10, 4, "This cooks too slow");
-- 5
INSERT INTO Dislike(userID, recipeID, reason) values(10, 5, "Feta cheese would make this better");
-- 6
INSERT INTO Dislike(userID, recipeID, reason) values(10, 6, "Too bland for me");
-- 7
INSERT INTO Dislike(userID, recipeID, reason) values(10, 7, "These things should not be mixed");
-- 8
INSERT INTO Dislike(userID, recipeID, reason) values(10, 8, "Could really use cranberry sauce");
-- 9
INSERT INTO Dislike(userID, recipeID, reason) values(10, 9, "What is elote");
-- 10
INSERT INTO Dislike(userID, recipeID, reason) values(10, 10, "Tofu is for losers");

-- Favorite inserts
-- 1
INSERT INTO Favorite(userID, recipeID, reason) values(2, 8, "I love this app! If I was a professor and this was a project it would get an A!");
-- 2
INSERT INTO Favorite(userID, recipeID, reason) values(2, 10, "Wow this is the best");
-- 3
INSERT INTO Favorite(userID, recipeID, reason) values(4, 3, "Maple syrup yum");
-- 4
INSERT INTO Favorite(userID, recipeID, reason) values(4, 4, "Such an easy meal to prep! Love it.");
-- 5
INSERT INTO Favorite(userID, recipeID, reason) values(5, 5, "America!");
-- 6
INSERT INTO Favorite(userID, recipeID, reason) values(5, 6, "Just how my mama made it");
-- 7
INSERT INTO Favorite(userID, recipeID, reason) values(6, 7, "Best enchiladas I've ever had");
-- 8
INSERT INTO Favorite(userID, recipeID, reason) values(6, 4, "Slow cookers are the best");
-- 9
INSERT INTO Favorite(userID, recipeID, reason) values(8, 9, "I have this every week");
-- 10
INSERT INTO Favorite(userID, recipeID, reason) values(8, 10, "The peanut suace is to die for");

-- Recipe_Culture inserts
-- 1
INSERT INTO Recipe_Culture(recipeID, cultureID) values(6, 1);
-- 2
INSERT INTO Recipe_Culture(recipeID, cultureID) values(9, 2);
-- 3
INSERT INTO Recipe_Culture(recipeID, cultureID) values(7, 2);
-- 4
INSERT INTO Recipe_Culture(recipeID, cultureID) values(5, 3);
-- 5
INSERT INTO Recipe_Culture(recipeID, cultureID) values(2, 3);
-- 6
INSERT INTO Recipe_Culture(recipeID, cultureID) values(3, 3);
-- 7
INSERT INTO Recipe_Culture(recipeID, cultureID) values(4, 3);
-- 8
INSERT INTO Recipe_Culture(recipeID, cultureID) values(8, 6);
-- 9
INSERT INTO Recipe_Culture(recipeID, cultureID) values(10, 6);
-- 10
INSERT INTO Recipe_Culture(recipeID, cultureID) values(4, 4);

-- recipe_ingredient inserts
-- 1
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 9, 4, "Tbs", "divided");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 10, 0.5, "lb", "boneless, cut into bite-sized pieces");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 2, 1, "Cup", "chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 5, 2, "Clove", "minced");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 11, 0.5, "Cup", "sliced");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 12, 0.5, "Cup", "chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 13, 5, "Cups", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 14, 1, "14.5 Ounce Can", "with basil, garlic and oregano");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 15, 1, "15.5 Ounce Can", "drained and rinsed");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 16, 1, "15.5 Ounce Can", "drained and rinsed");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 17, 1, "6 Ounce Can", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 18, 1, "Small", "quartered lengthwise and cut into 0.5 inch slices");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 19, 0.5, "Cup", "frozen, cut");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 20, 1, "tsp", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 21, 0.5, "Cup", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 22, 1, "to taste", "freshly ground");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 23, 1, "to taste", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 24, 0.33, "Cup", "grated");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(1, 25, 2, "tsp", "fresh, chopped");

-- 2
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(2, 26, 12, "Ounce", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(2, 27, 1, "Cup", "white");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(2, 28, 1, "Cup", NULL);

-- 3
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(3, 29, 1, "lb", "whole");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(3, 30, 4, "Slice", "cut into 0.5 inch pieces");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(3, 23, 0.5, "tsp", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(3, 22, 0.25, "tsp", "freshly ground");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(3, 9, 0.25, "cup", "extra-virgin");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(3, 31, 3, "Tbsp", "pure");

-- 4
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 32, 1, "Cup", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 2, 2, "Cup", "chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 12, 2, "Cup", "chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 33, 12, "Ounce", "sliced");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 25, 0.25, "Cup", "fresh, chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 34, 12, "Cup", "dry, cubed");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 23, 1.5, "tsp", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 35, 1.5, "tsp", "dried");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 36, 1, "tsp", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 22, 0.5, "tsp", "ground");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 13, 4.5, "Cup", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(4, 39, 2, "Large", "beaten");

-- 5
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 40, 6, "Cup", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 41, 1, "7.25 Ounce Box", "KRAFT Macaroni & Cheese Dinner");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 6, 0.25, "Cup", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 42, 0.25, "Cup", "cut up");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 43, 1.5, "Cup", "shredded");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 2, 0.33, "Cup", "chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 44, 1, "Whole", "seeded, chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 39, 1, "Large", "lightly beaten");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 45, 1, "tsp", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 46, 1, "tsp", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 47, 1, "tsp", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 48, 1, "lb", "thawed");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 49, 0.25, "Cup", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(5, 50, 0.25, "Cup", "or to taste");

-- 6
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(6, 9, 0.5, "Cup", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(6, 51, 2, "Whole", "juiced");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(6, 5, 3, "Clove", "chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(6, 52, 1, "Tbsp", "fresh, chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(6, 37, 1, "Tbsp", "fresh, chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(6, 53, 1, "Tbsp", "fresh, chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(6, 54, 4, "lb", "cut into pieces");

-- 7
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 55, 32, "Extra-Large", "peeled, deveined");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 23, 0.5, "tsp", "more as needed");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 56, 1, "pinch", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 57, 2, "Tbsp", "more as needed");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 58, 1, "Cup", "diced");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 2, 1, "Cup", "diced");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 59, 2, "Tbsp", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 47, 2, "tsp", "smoked");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 60, 1, "tsp", "ground");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 22, 0.5, "tsp", "freshly ground");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 61, 0.25, "tsp", "ground");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 5, 3, "Clove", "minced");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 40, 0.5, "Cup", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 62, 2, "15 Ounce Can", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 17, 2, "Tbps", "optional");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 63, 2, "Tbsp", "rounded, chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 64, 6, "Ounce", "shredded");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 65, 6, "Ounce", "shredded");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 44, 1, "Whole", "thinly sliced, more to taste");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 66, 2, "Whole", "thinly sliced, more to taste");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 8, 0.5, "Cup", "as needed");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 67, 1, "Tbsp", "as needed");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(7, 68, 1, "Whole", "cut into wedges for serving");

-- 8
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(8, 81, 4, "Tbsp", "can be extra-virgin olive oil, divided");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(8, 73, 1, "14 Ounce", "patty dry, cut itno 0.5 inch cubes");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(8, 23, 1, "tsp", "as needed, Kosher");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(8, 2, 2, "Medium", "coarsely chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(8, 18, 2, "Large", "cut itno 0.5 inch pieces");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(8, 83, 1, "Large", "cut into 0.5 inch pieces");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(8, 19, 8, "Ounce", "trimmed, cut into 1 inch pieces");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(8, 84, 1, "13.4 Ounce Can", "unsweetened");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(8, 82, 0.66, "Cup", NULL);

-- 9
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(9, 69, 0.5, "Cup", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(9, 68, 1, "Whole", "juiced");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(9, 67, 1, "tsp", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(9, 59, 0.5, "tsp", "mild");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(9, 47, 0.25, "tsp", "smoked");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(9, 71, 0.5, "Cup", "crumbled");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(9, 63, 0.5, "Cup", "coarsely chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(9, 72, 3, "Whole", "sliced");

-- 10
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 73, 1, "14 Ounce Block", NULL);
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 57, 2, "Tbsp", "Simply nature Avocado Oil");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 75, 0.5, "Small", "shredded");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 11, 1.5, "Cup", "shredded");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 63, 0.5, "Cup", "roughly chopped");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 68, 3, "Tbsp", "juiced");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 9, 1, "Tbsp", "Simply Nature Organic Extra Virgin Olive Oil");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 76, 1, "Tbsp", "toasted");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 23, 0.5, "tsp", "sea");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 22, 1, "tsp", "to taste, freshly cracked");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 77, 4, "Tbsp", "Simply Nature Creamy Peanut Butter");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 78, 1, "Tbsp", "or maple syrup");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 79, 2, "tsp", "tamari for gluten-free");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 80, 1, "tsp", "2 if needed");
INSERT INTO Recipe_Ingredient(recipeID, ingredientID, quantity, quantityUnit, notes) values(10, 40, 2, "Tbsp", "as needed");








-- type restriction: ----------------------------------
INSERT INTO `Type_Restriction`(`typeID`,`userID`) VALUES
-- connor is dairy-free:
(3, 1), 
-- ken is vegan:
(2, 2), 
-- james pham doesnt eat pork or treenuts or any nuts:
(4, 10),
(22, 10),
(7, 10),
-- Hugo Hammond doesnt eat pork, dairy, alcohol or shellfish:
(7, 4),
(3, 4),
(19, 4),
(17, 4),
-- zane berry 5 doesnt eat meat -- but he does eat fish
(6, 5);

-- ingredient restriction: -----------------------------
INSERT INTO `Ingredient_Restriction`(`userID`,`ingredientID`) VALUES
-- Hugo Hammond 4 doesnt like brussel sprouts, mushrooms or cannelinni beans
(4, 29),
(4, 15),
(4, 33),
-- Zane berry doesnt like poblano peppers
(5, 58),
-- christina meyers 7 doesnt like bblack pepper, maple syrup, bacon, parmesan cheese
(7, 31),
(7, 30),
(7, 22),
(7, 24),
-- dana doesnt like margarine, 
(3, 42),
-- connor doesnt like carrot
(1, 11);


