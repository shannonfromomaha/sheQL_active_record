
ActiveRecord is not a new programming language--it’s still Ruby, which we’ve been working in the last few weeks--
but ActiveRecord is a Ruby library, meaning it’s a collection of code shortcuts. In this case, it’s an 
ORM (Object Relational Mapping) library, which ties the tables to their objects, and objects to their columns. 
These are shortcuts that make working in Ruby databases much, much easier.

From your Cloud9 command line, run
```$ bundle install```
This will install all the gems you’ll need for these first few exercises. 

We’ll also need postgres, so run:
```$ sudo service postgresql start```

Test postgres is working:
```$ psql```
And you should see:
postgres=#


(\q quits postgres.)

Then, set up postgres for Cloud9. (Only needs to happen once.)
```$ rake db:setupC9```
Rake is a Ruby task. So the above is running a chunk of Ruby code to set up databases(db) in Cloud9. 
We’re going to call a lot of rake tasks today, but if you end up liking them a lot you can write your own! 
If you just type ```rake```  It will list all the rake tasks available to you.
Create your database. (This only needs to happen once.)
```$ rake db:create```


Exercise 1: Creating a Migration
Migrations are how ActiveRecord makes changes to the database structure. In weeks past we’ve represented tables in a database as spreadsheets, like so:
Animals:
ID     |   name        |   legs   |
1         chinchilla       four
2         centipede        Like a hundred?

So let’s make this table using ActiveRecord.
```$ rake g:migration create_animals```
This will generate a new migration file in your project under db/migrate.
Note: After the “rake g:migration “ you can put anything, as long as it’s in snake_case. 
However, if you name your migrations well (I like “thing it’s gonna do”_”what table it’s doing it to”) you will appreciate it later.
Open the new migration file you just created, and you’ll find an empty migration that probably looks a lot like this:

  ```
  class CreateAnimals < ActiveRecord::Migration[5.0]
    def change
    end
  end
  ```

```def change  end``` might look familiar--that’s an empty Ruby method! You’ve written those before. 
What we write inside of the change method is the change we want to make to the database when we call this migration task. 
Since we have no tables, we should make one.
  ```
  class CreateAnimals < ActiveRecord::Migration[5.0]
    def change
      create_table :animals do |t|
        t.string :name
        t.string :legs
      end
    end
  end
```

Save and close.
Notice, you didn’t make an id, even though that’s an important column. ActiveRecord will create a sequential id for you 
(useful when your application has millions of users). Also, you have to declare the data type of all your fields as well. This is super important.
Run the migration.
```$ rake db:migrate```
Now you have a TABLE! Woo! Let's load ruby and see if we can access our Animal table and insert the first record.
```$ irb  ```
         
```require './app.rb'```


^ running these commands give you a very similar command line to what you had in repl.it and through the command line you can create a new animal record.
```
chinchilla = Animal.new
=> #<Animal id: nil, name: nil, legs: nil>
chinchilla.name = ‘Chinchilla’
 => "Chinchilla"
chinchilla.legs = 4
 => “4”
chinchilla.save
=> true
```

IMPORTANT NOTE: once you “run” migrations, DO NOT EDIT OR DELETE THE MIGRATION FILE. If you forgot a field or you want to delete a table, WRITE A NEW MIGRATION.
Exercise: Create a migration to create a User table in your cloud9 project. Think of two fields that would be stored 
and what data type would be most appropriate to store that data. Run your migrations and save a few test users through the command line!

*******

Exercise 2: Editing existing databases
So, we shouldn’t edit or delete existing migration files, but that doesn’t mean we can’t change the data structure. 
We definitely need the ability to do that as the requirements of our application changes.
We can add new columns to our existing tables:
 ```$ rake g:migration add_tails_to_animals```
 ```
class AddTailsToAnimals < ActiveRecord::Migration
  def change
    add_column :animals, :tails, :string
  end
end
```
Notice the order here--first you define the action (add_column), then the table (:animals) then the name of the new column (:tails), then the data type (:string)
You can also rename a column:
```
def change 
  rename_column :animals, :tails, :fluffysticks 
end
```
Then the order is action, table, old column name, new column name.
Exercise: Create some migrations to edit your User table. Add a few new columns. 
Change one of the new columns names to be something else. 
Then delete the silliest column. 
I KNOW I DIDN’T SHOW YOU HOW TO DELETE A COLUMN. I have confidence in your googling skills ;)




BONUS (we’ll be discussing Validations and Has Many/Belongs To in class, but if you’re going really fast you miiiiight be able to google the answers to these)
Validations Exercises: 
Add a column in your user table that can’t be blank. Try to save a record without that value and see what happens.
Add a column with a default value.
Add a validation for a column that has an integer datatype. Make sure it doesn’t save if the number is greater than 100.

Has Many/Belongs To Exercises:
Think of something that would belong to your Users. Pets? Toothbrushes? Phones? Create a new table for that object, and define that it belongs to Users. Update your User model so it knows it has many toothbrushes (or what have you)





