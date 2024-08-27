import unittest
import connection as c

##############################################
#Some unit Testing



############################################
########## TESTING RECIPE SEARCH ###########
############################################


TYPE_LIST = [2, 3, 6] #animal product
SPICELEVEL = 3
TIME = 25
AUTHORID = 2
CULTUREID = 6
INGREDIENTS_INCLUDE = [73, 18, 83] ##tofu, zucchini, eggplant 
INGREDIENTS_EXCLUDE = [10, 54, 62, 65, 67] ##chicken breast, chicken, lobster bisque soup, cheddar cheese, hot sauce 


'''
TYPE_LIST = [8] #fruit
SPICELEVEL = 5
TIME = 120
AUTHORID = None
CULTUREID = None
INGREDIENTS_INCLUDE = [23] ##salt  recipes are: 
INGREDIENTS_EXCLUDE = [84] ##coconut milk
'''

class TestRecipeSearch(unittest.TestCase):
    ## searchRecipe(typeIdVarLIST, spiceLvlVar, timeVar, authorIdVar, cultureIdVar, ingreRestrictionVarLIST, ingreInclusionVarLIST)

    ## GIVEN ALL CORRECT DATA:
    def test_correctData(self):

        recipeList = c.searchRecipe(TYPE_LIST, SPICELEVEL, TIME, AUTHORID, CULTUREID, INGREDIENTS_EXCLUDE, INGREDIENTS_INCLUDE)
        for recipeID in recipeList:
            #testing type:
            for type in TYPE_LIST:
                ingredientsInType = c.getIngredientsInType(type)
                for ingredient in ingredientsInType:
                    self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))
            
            #testing spice:
            self.assertLessEqual(c.getRecipeSpice(recipeID), SPICELEVEL)

            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)

            #testing culture:
            self.assertEqual(c.getRecipeCultureID(recipeID), CULTUREID)

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                self.assertTrue(ingredient in c.getRecipeIngredientsID(recipeID))

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))
            


## GIVEN NULL/EMPTY typeIdVarLIST:
    def test_noType(self):

        recipeList = c.searchRecipe([], SPICELEVEL, TIME, AUTHORID, CULTUREID, INGREDIENTS_EXCLUDE, INGREDIENTS_INCLUDE)
        for recipeID in recipeList:

            #testing spice:
            self.assertLessEqual(c.getRecipeSpice(recipeID), SPICELEVEL)

            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)

            #testing culture:
            self.assertEqual(c.getRecipeCultureID(recipeID), CULTUREID)

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                self.assertTrue(ingredient in c.getRecipeIngredientsID(recipeID))

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))
            


## GIVEN NULL spiceLvlVar:
    def test_noSpice(self):       
        recipeList = c.searchRecipe(TYPE_LIST, None, TIME, AUTHORID, CULTUREID, INGREDIENTS_EXCLUDE, INGREDIENTS_INCLUDE)
        for recipeID in recipeList:
            #testing type:
            for type in TYPE_LIST:
                ingredientsInType = c.getIngredientsInType(type)
                for ingredient in ingredientsInType:
                    self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))

            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)

            #testing culture:
            self.assertEqual(c.getRecipeCultureID(recipeID), CULTUREID)

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                self.assertTrue(ingredient in c.getRecipeIngredientsID(recipeID))

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))
            


## GIVEN NULL timeVar:
    def test_noTime(self):
        recipeList = c.searchRecipe(TYPE_LIST, SPICELEVEL, None, AUTHORID, CULTUREID, INGREDIENTS_EXCLUDE, INGREDIENTS_INCLUDE)
        for recipeID in recipeList:
            #testing type:
            for type in TYPE_LIST:
                ingredientsInType = c.getIngredientsInType(type)
                for ingredient in ingredientsInType:
                    self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))
            
            #testing spice:
            self.assertLessEqual(c.getRecipeSpice(recipeID), SPICELEVEL)

            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)

            #testing culture:
            self.assertEqual(c.getRecipeCultureID(recipeID), CULTUREID)

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                self.assertTrue(ingredient in c.getRecipeIngredientsID(recipeID))

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))

## GIVEN NULL authorIdVar:
    def test_noAuthor(self):
        recipeList = c.searchRecipe(TYPE_LIST, SPICELEVEL, TIME, None, CULTUREID, INGREDIENTS_EXCLUDE, INGREDIENTS_INCLUDE)
        for recipeID in recipeList:
            #testing type:
            for type in TYPE_LIST:
                ingredientsInType = c.getIngredientsInType(type)
                for ingredient in ingredientsInType:
                    self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))
            
            #testing spice:
            self.assertLessEqual(c.getRecipeSpice(recipeID), SPICELEVEL)

            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing culture:
            self.assertEqual(c.getRecipeCultureID(recipeID), CULTUREID)

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                self.assertTrue(ingredient in c.getRecipeIngredientsID(recipeID))

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))

## GIVEN NULL cultureIdVar:
    def test_noCulture(self):
        recipeList = c.searchRecipe(TYPE_LIST, SPICELEVEL, TIME, AUTHORID, None, INGREDIENTS_EXCLUDE, INGREDIENTS_INCLUDE)
        for recipeID in recipeList:
            #testing type:
            for type in TYPE_LIST:
                ingredientsInType = c.getIngredientsInType(type)
                for ingredient in ingredientsInType:
                    self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))
            
            #testing spice:
            self.assertLessEqual(c.getRecipeSpice(recipeID), SPICELEVEL)

            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                self.assertTrue(ingredient in c.getRecipeIngredientsID(recipeID))

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))

## GIVEN NULL/EMPTY ingreRestrictionsVarList:
    def test_noRestrictedIngre(self):
        recipeList = c.searchRecipe(TYPE_LIST, SPICELEVEL, TIME, AUTHORID, CULTUREID, [], INGREDIENTS_INCLUDE)
        for recipeID in recipeList:
            #testing type:
            for type in TYPE_LIST:
                ingredientsInType = c.getIngredientsInType(type)
                for ingredient in ingredientsInType:
                    self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))
            
            #testing spice:
            self.assertLessEqual(c.getRecipeSpice(recipeID), SPICELEVEL)

            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)

            #testing culture:
            self.assertEqual(c.getRecipeCultureID(recipeID), CULTUREID)

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                self.assertTrue(ingredient in c.getRecipeIngredientsID(recipeID))

## GIVEN NULL/EMPTY ingreInclusionsVarList:
    def test_noIncludedIngre(self):
        recipeList = c.searchRecipe(TYPE_LIST, SPICELEVEL, TIME, AUTHORID, CULTUREID, INGREDIENTS_EXCLUDE, [])
        for recipeID in recipeList:
            #testing type:
            for type in TYPE_LIST:
                ingredientsInType = c.getIngredientsInType(type)
                for ingredient in ingredientsInType:
                    self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))
            
            #testing spice:
            self.assertLessEqual(c.getRecipeSpice(recipeID), SPICELEVEL)

            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)

            #testing culture:
            self.assertEqual(c.getRecipeCultureID(recipeID), CULTUREID)

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))

## GIVEN A COMBINATION OF NULL/EMPTY VARIABLES:
    def test_MultipleNullVals_Type_IngreExclude_IngreInclude(self):
        recipeList = c.searchRecipe([], SPICELEVEL, TIME, AUTHORID, CULTUREID, [], [])
        for recipeID in recipeList:
            
            #testing spice:
            self.assertLessEqual(c.getRecipeSpice(recipeID), SPICELEVEL)

            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)

            #testing culture:
            self.assertEqual(c.getRecipeCultureID(recipeID), CULTUREID)


    def test_MultipleNullVals_Type_Spice_Culture_Author(self):
        recipeList = c.searchRecipe([], None, TIME, None, None, INGREDIENTS_EXCLUDE, INGREDIENTS_INCLUDE)
        for recipeID in recipeList:
            
            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                recipeIngredients = c.getRecipeIngredientsID(recipeID)
                self.assertTrue(ingredient in recipeIngredients)

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))


    def test_MultipleNullVals_IngreExclude_IngreInclude_Culture_Spice(self):
        recipeList = c.searchRecipe(TYPE_LIST, None, TIME, AUTHORID, None, [], [])
        for recipeID in recipeList:
            #testing type:
            for type in TYPE_LIST:
                ingredientsInType = c.getIngredientsInType(type)
                for ingredient in ingredientsInType:
                    ingredientList = c.getRecipeIngredientsID(recipeID)
                    self.assertTrue(ingredient not in ingredientList)

            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)
    
    
    def test_MultipleNullVals_Author_Spice_Time(self):
        recipeList = c.searchRecipe(TYPE_LIST, None, None, None, CULTUREID, INGREDIENTS_EXCLUDE, INGREDIENTS_INCLUDE)
        for recipeID in recipeList:
            #testing type:
            for type in TYPE_LIST:
                ingredientsInType = c.getIngredientsInType(type)
                for ingredient in ingredientsInType:
                    self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))

            #testing culture:
            self.assertEqual(c.getRecipeCultureID(recipeID), CULTUREID)

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                self.assertTrue(ingredient in c.getRecipeIngredientsID(recipeID))

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))

    def test_MultipleNullVals_Type_Spice_Culture(self):
        recipeList = c.searchRecipe([], None, TIME, AUTHORID, None, INGREDIENTS_EXCLUDE, INGREDIENTS_INCLUDE)
        for recipeID in recipeList:
            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                self.assertTrue(ingredient in c.getRecipeIngredientsID(recipeID))

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))


## GIVEN ALL NULL VARIABLES:
    def test_AllNullVals(self):
        recipeList = c.searchRecipe([], None, None, None, None, [], [])
        for recipeID in recipeList:
            ##testing that all recipes are returned:
            allRecipes = c.getAllRecipes()
            self.assertTrue(recipeID in allRecipes)

## GIVEN ONLY TYPE LIST:
    def test_OnlyGivenTypeList(self):
        recipeList = c.searchRecipe(TYPE_LIST, None, None, None, None, [], [])
        for recipeID in recipeList:
            #testing type:
            for type in TYPE_LIST:
                ingredientsInType = c.getIngredientsInType(type)
                for ingredient in ingredientsInType:
                    self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))

## GIVEN ONLY SPICE:
    def test_OnlyGivenSpice(self):
        recipeList = c.searchRecipe([], SPICELEVEL, None, None, None, [], [])
        for recipeID in recipeList:
            #testing spice:
            self.assertLessEqual(c.getRecipeSpice(recipeID), SPICELEVEL)

## GIVEN ONLY TIME:
    def test_OnlyGivenTime(self):
        recipeList = c.searchRecipe([], None, TIME, None, None, [], [])
        for recipeID in recipeList:
            #testing time:
            self.assertLessEqual(c.getRecipeTime(recipeID), TIME)

## GIVEN ONLY AUTHOR:
    def test_OnlyGivenAuthor(self):
        recipeList = c.searchRecipe([], None, None, AUTHORID, None, [], [])
        for recipeID in recipeList:
            #testing author:
            self.assertEqual(c.getRecipeAuthorID(recipeID), AUTHORID)

## GIVEN ONLY CULTURE:
    def test_OnlyGivenCulture(self):
        recipeList = c.searchRecipe([], None, None, None, CULTUREID, [], [])
        for recipeID in recipeList:

            #testing culture:
            self.assertEqual(c.getRecipeCultureID(recipeID), CULTUREID)
    

## GIVEN ONLY INGREDIENT RESTRICTION LIST:
    def test_OnlyGivenRestrictedIngre(self):
        recipeList = c.searchRecipe([], None, None, None, None, INGREDIENTS_EXCLUDE, [])
        for recipeID in recipeList:

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                ingredientsInRecipe = c.getRecipeIngredientsID(recipeID)
                self.assertTrue(ingredient not in ingredientsInRecipe)


## GIVEN ONLY INGREDIENT INCLUSION LIST:
    def test_OnlyGivenIncludedIngre(self):
        recipeList = c.searchRecipe([], None, None, None, None, [], INGREDIENTS_INCLUDE)
        for recipeID in recipeList:

            #testing ingredients to include:
            for ingredient in INGREDIENTS_INCLUDE:
                self.assertTrue(ingredient in c.getRecipeIngredientsID(recipeID))

            #testing ingredients to exclude:
            for ingredient in INGREDIENTS_EXCLUDE:
                self.assertTrue(ingredient not in c.getRecipeIngredientsID(recipeID))


'''
###########################################
######### TESTING GET FUNCTIONS ###########
###########################################
## connor is handling these

#############################################
######## TESTING DATABASE UPDATING ##########
#############################################

#not sure how to test this one yet
class TestCreateUserSQL(unittest.TestCase):
    pass

class TestVerifyLogin(unittest.TestCase):
    pass

class TestUpdateUserTypeRestriction(unittest.TestCase):
    pass

class TestUpdateFavorite(unittest.TestCase):
    pass

class TestUpdateDislike(unittest.TestCase):
    pass

#####################
##### SECURITY ######

test checkEmailUnique(email: str) 

test validateRecipeID(recipeID)

test crossCompareINCLUSIVE(ListOfLists: list)

'''
###*****************************************************###
###*****************************************************###

if __name__ == '__main__':
    unittest.main()

