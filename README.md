# Recipe Gen

## Description

A tool to generate cook books using a basic XML recipe format described below. 


## Dependencies

+	pdflatex
	+	`apt-get install texlive-latex-extra`
+	[texml](http://getfo.org/texml/)
	+	Download and install from source


## Installation

	git clone <REPO URL>
	cd recipe-gen
	sudo make install


## Usage

	recipe-gen <Path to RECIPE-BOOK.xml>


## XML Format

Some elements/attributes listed below are listed as required and/or optional. If an required elements/attributes are missing, I don't think it will break anything. Likewise, in certain cases if optional elements/attributes are missing, it might break. YMMV.


### Recipe

+	`/recipe/name`
	+	Name of the recipe.
	+	Required
+	`/recipe/source`
	+	Source of the recipe.
	+	Required
+	`/recipe/source/a/@href`
	+	Link to a webpage.
	+	Optional. Required if element `/recipe/source/a` exists.
+	`/recipe/source/a/text()`
	+	Text associated with the link.
	+	Optional.
+	`/recipe/source/ingredients`
	+	Lists the ingredients in the recipe.
	+	Required.
+	`/recipe/source/ingredients/@heading`
	+	Name of the section of ingredients.
	+	Useful if there are multiple 'sub recipes' within the recpie (eg. crust, topping, etc).
	+	Optional.
+	`/recpie/source/ingredients/ingredient/`
	+	Individual ingredient in the recipe
	+	Required.
+	`/recipe/source/ingredients/ingredient/amount`
	+	Amount of the individual ingredient in the recipe.
	+	Has attributes:
		+	`@value`
		+	`@unit`
			+	Special unit "natural" will hide the unit (useful for describing "3 Large Eggs", for example.)
	+	One or more required.
		+	Only first one is used at the moment. Others can be added for different measuring systems.
+	`/recipe/source/ingredients/ingredient/name`
	+	Name of the ingredient
	+	What would be listed on a potential grocery list
	+	Required.
+	`/recipe/source/ingredients/ingredient/note`
	+	What to do with the ingredient prior to starting the recipe.
		+	Example: A recipe calls for a sliced apple as an ingredient. You could put "Apple" as the name of the ingredient and "sliced" as a note.
	+	Optional. More then one is allowed.
+	`/recipe/source/directions/`
	+	Lists the directions for the recipe.
	+	Required.
+	`/recipe/source/directions/@heading`
	+	Name of the section of directions.
	+	Useful if there are multiple 'sub recipes' within the recipe (eg. crust, topping, etc)
	+	Optional.
+	`/recipe/source/directions/step`
	+	An individual step in the list of directions.
	+	Required.


#### Example


	<recipe>
		<title>
			Bread Muffins
		</title>
		<source>
			My Kitchen
		</source>
		<ingredients>
			<ingredient>
				<amount value='1' unit='cup' />
				<name>
					Warm Water
				</name>
			</ingredient>
			<ingredient>
				<amount value='1.25' unit='tsp' />
				<name>
					Yeast
				</name>
			</ingredient>
			<ingredient>
				<amount value='0.25' unit="tbsp" />
				<name>
					Sugar
				</name>
			</ingredient>
			<ingredient>
				<amount value='some' unit="natural" />
				<name>
					Bread Flour
				</name>
			</ingredient>
		</ingredients>
		<directions>
			<step>
				Preheat oven to 375F.
			</step>
			<step>
				Mix water, yeast, and sugar.
			</step>
			<step>
				Let yeast spawn for about 15 min.
			</step>
			<step>
				Mix in flour until bread dough consistancy.
			</step>
			<step>
				Cut dough in to muffin sized chunks and place in muffin tin. Make sure the outside of the dough balls are coverd in flour and not sticky.
			</step>
			<step>
				Let rise on the oven vent.
			</step>
			<step>
				Bake for 20 - 25 min.
			</step>
		</directions>
	</recipe>



### Recipe Book

+	`/recipe-book/title`
	+	A title for the recipe book.
	+	Required
+	`/recipe-book/author`
	+	The author/compiler/editor for the recipe book.
	+	Required
+	`/recipe-book/recipes`
	+	A section of recipes
	+	One (or more) required
+	`/recipe-book/recipes/@heading`
	+	A heading to separate different sections of the book.
	+	Required if more then one `/recipe-book/recipes` elements.
	+	Optional if only one `/recipe-book/recipe` element.
+	`/recipe-book/recipes/recipe`
	+	Contents of a single recipe
	+	Required
+	`/recipe-book/recipes/recipe/@href`
	+	The path to a recipe.
	+	Optional.
	+	Required if `/recipe-book/recipes/recipe/<subelements>` is empty.
	+	Takes precidance over the contents of `/recipe-book/recipes/recipe`.
+	`/recipe-book/recipes/recipe/<subelements>`
	+	Information on a recipe.
	+	Follows the same format as a separate recipe xml.




#### Example

	<recipe-book>
		<title>
			Recipe Book
		</title>

		<author>
			Aaron Herting
		</author>

		<recipes heading="Dinners">
			<recipe href="recipes/helgas_red_cabbage.xml" />
		</recipes>

		<recipes heading="Breads">
			<recipe>
				<title>
					Bread Muffins
				</title>
				<source>
					My Kitchen
				</source>
				<ingredients>
					<ingredient>
						<amount value='1' unit='cup' />
						<name>
							Warm Water
						</name>
					</ingredient>
					<ingredient>
						<amount value='1.25' unit='tsp' />
						<name>
							Yeast
						</name>
					</ingredient>
					<ingredient>
						<amount value='0.25' unit="tbsp" />
						<name>
							Sugar
						</name>
					</ingredient>
					<ingredient>
						<amount value='some' unit="natural" />
						<name>
							Bread Flour
						</name>
					</ingredient>
				</ingredients>
				<directions>
					<step>
						Preheat oven to 375F.
					</step>
					<step>
						Mix water, yeast, and sugar.
					</step>
					<step>
						Let yeast spawn for about 15 min.
					</step>
					<step>
						Mix in flour until bread dough consistancy.
					</step>
					<step>
						Cut dough in to muffin sized chunks and place in muffin tin. Make sure the outside of the dough balls are coverd in flour and not sticky.
					</step>
					<step>
						Let rise on the oven vent.
					</step>
					<step>
						Bake for 20 - 25 min.
					</step>
				</directions>
			</recipe>
		</recipes>
	</recipe-book>



