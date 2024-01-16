-- ===================================================================
-- @authors: Dana Cavanagh, Connor George
-- created:	Nov. '23
-- last updated: Nov. '23
-- purpose: the purpose of this document was to demonstrate proof of database
-- 			concept through a few example queries. This document remains
-- 			just as a remnant from the initial database design period, but
--          does not serve a purpose in the database scheme.
-- ===================================================================


USE `cookBooked` ;

-- 1) show a recipe that is vegan, has a spice level of less than 4 and takes less than 60 minutes to prepare
select 
    title,
    timeEstimate,
    spiceLevel
from
    Recipe r
where r.recipeID not in
	( select r.recipeID
	  from Recipe as r
	  inner join Recipe_Ingredient ri on r.recipeID = ri.recipeID
	  where ri.ingredientID in
		(
			select ingredientID
			from Ingredient_Type it
			where it.typeID = 2
		)
	)
    and
    spiceLevel < 4
    and
    timeEstimate < 60
    group by
    title,
    timeEstimate,
    spiceLevel;


-- 2) show all ingredients restricted for user ken whitener
SELECT DISTINCT
    I.name as "Restricted Ingredients (in database)"
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
                    u.firstName = "Ken"
            )
	)
    OR I.ingredientID in(
    select i.ingredientID from Ingredient as i
    inner join Ingredient_Restriction as ir on i.ingredientID = ir.ingredientID
    where ir.userID = userVAR );
    

-- 3) show the most liked recipe 
SELECT r.title as "Title", count(f.recipeID) as "Number of Favorites"
from Recipe as r
inner join Favorite as f on r.recipeID = f.recipeID
group by r.title
order by count(f.recipeID) DESC
limit 1;

-- 4) show all recipes made with the ingredient hot sauce
SELECT r.title as "Title"
from Recipe as r
inner join Recipe_Ingredient as ri on r.recipeID = ri.recipeID
inner join Ingredient as i on ri.ingredientID = i.ingredientID
where i.name = "hot sauce";



-- 5) select all Moonese recipes
select
    concat(u.firstName, " ", u.lastName) as "Author",
    r.title
from
    Recipe r
    inner join Recipe_Culture rc on r.recipeID = rc.recipeID
    inner join Culture c on rc.cultureID = c.idCulture
    inner join User u on r.authorID = u.userID
where
    c.name = "Moonese";
    
    
-- 6) select all of Hugo's favorited recipes that have ingredient types Connor can eat
select
    concat(author.firstName, " ", author.lastName) as "Author",
    r.title
from 
    Recipe r
    inner join Favorite f on r.recipeID = f.recipeID
    inner join User u on f.userID = u.userID
    inner join User author on r.authorID = author.userID
where
    u.firstName = "Hugo"
    and 
    r.recipeID not in
    (
        select
            r.recipeID
        from
            Recipe r
            inner join Recipe_Ingredient ri on r.recipeID = ri.recipeID
            inner join Ingredient i on ri.ingredientID = i.ingredientID
            inner join Ingredient_Type it on i.ingredientID = it.ingredientID
            inner join Type t on it.typeID = t.typeID
        where
            t.typeID in
            (
                select
                    tr.typeID
                from
                    Type_Restriction tr
                    inner join User u on tr.userID = u.userID
                where
                    u.firstName = "Connor"
            )
    );
    
    
    
    
    
    
    
    

