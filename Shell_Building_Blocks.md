Shell Building Blocks
=====================

Introduction
------------

Hello, everyone. I'm Peter Bukowinski. I was a Mac Admin until late 2008, when I became a linux sysadmin. Since OS X I've been using the shell to solve problems and to complete my regular tasks faster. (Incidentally, when I say shell, I mean bash. There are many shells to choose from, but bash is the default so that's what I'm focusing on.)

2008 was just seven short years ago, and it was a much different time in the Mac Admin world than today. The number of people writing code collaboratively, or individually, to solve problems shared by the whole community was pretty small. InstaDMG was brand-new in the summer of 2008, and was written entirely in bash. Since then, it has undergone countless revisions by a growing number of collaborators, switched to python, and was recently superseded by AutoDMG. It's one of many examples that tells you coding is clearly a trending skill among Mac admins.

Since you're here, you probably already know this, and it may be why you picked this session over others. Hopefully, you're here because you want to solidify your knowledge of the essentials for shell scripting. If you're already an experienced shell scripter, you may pick up a few things, but this might not be the right session for you.

Before I start, I want to mention that you can find my presentation notes and supporting material for this talk on github: [https://github.com/pmbuko/shell-building-blocks]()

Brief Survey
------------
I'd like to get a grasp of your level of experience before continuing.

1. Is everyone here familiar with navigational shell commands like ls, cd, and pwd?
2. How about file-based commands like cp, mv, rm, and mkdir?
4. And are you all familiar with using shell options and arguments with commands, such as 'rm -rf /blah'?

Because of time constraints, I will not be covering these during the session. There are plenty of online resources available to you, some of which I've listed in [ADDITIONAL_RESOURCES.md](https://github.com/pmbuko/shell-building-blocks/blob/master/ADDITIONAL_RESOURCES.md) at my github repo.

Where to start?
---------------
One of the people instrumental to the creation of UNIX, Dennis Ritchie, once said:

>UNIX is basically a simple operating system, but you have to be a genius to understand the simplicity.
The part after the comma can be intimidating to beginners, so let's just ignore it. You don't need to *understand* the simplicity to make use of it. As with most new things that seem overwhelming at first, breaking them down into smaller pieces makes them easier to grasp. Luckily, UNIX and the shell come pre-divided into bite-size chunks, and you don't have to learn all of a shell program's features to start taking advantage of it.
Remember, big things are made from smaller things.Before you build commands or shell scripts, you should understand how the *language* of UNIX works. Using the Lego metaphor I adopted for this talk, the grammar of the language describes how the blocks -- which you can also think of as the vocabulary -- interlock. Let's start with some basic grammar.

Spaces, Quoting, and Character Escaping
---------------------------------------
It's important to understand how and when to use quotes and spaces in the shell.

1. Any time you might have a space as part of input, use quotes. This means pretty much *any* time you're dealing with words and not numbers, expecially when defining variables.
2. Any time you want to store a string in a variable, use double-quotes. (What's a string? Anything not purely numerical.)

Let's look at three different examples. First, I'm setting a variable's value to the number 50. Note that I do not use spaces between the variable name, the equal sign, or the variable value. When setting numeric values, you don't need to use quotes.

    > folders=50
    
    > echo "I have $folders folders."
    I have 50 folders.
    
In this example, you see that when I use double quotes to echo some output, the $items variable is replaced by its assigned value.
    
    > echo "I have \$folders folders."
    I have $folders folders.
    
Here, since I used a backlash to escape the dollar sign, it is printed as a literal character and not part of a variable.
    
    > echo 'I have $folders folders.'
	I have $folders folders.
	
Here, you can see that using single quotes around a string causes the shell to interpret everything literally.

	> echo I have $folders folders.
	I have 50 folders.
	
In this particular case, the quotes are actually not required, but that doesn't mean you shouldn't always use them. You want to have consistency and readability in your code.
	
Escaping characters is necessary whenever you need the shell to pass along a literal character to a command instead of interpreting it. For example, this command will fail:

	> cd /Library/Application Support
	
but these commands will succeed:

    > cd /Library/Application\ Support
    > cd "/Library/Application Support"
    
By either escaping the space or quoting the entire path, you're telling the shell to view the space as part of the path and not a break in your input.

What if you were writing a script that reported which user's home directories had more that 5TB of data in them and you wanted it to output something like this:

	[username]'s home exceeds 5TB!
	
If you try an echo command like this:

	> username="Bob"
	> echo "$username's home exceeds 5TB!"

You'll get an error:

	bash: !": event not found
	
So bash doesn't seem to like the exclamation point. Maybe we need to escape it.

	> echo "$username's home exceeds 5TB\!"
	Bob's home exceeds 5TB\!
	
Hmmm. Nope. Let's try another trick.

	> echo "$username's home exceeds 5TB"'!'
	Bob's home exceeds 5TB!
	
There we are! This shows you that you can mash -- or concatenate -- various string parts together as long as you don't put a space between them.

One more example of quoting involves boundaries between variables and strings when you want to concatenate the two. Say you're writing a script that renames a file by appending some numbers to the end of the filename. You can't simply do this:

	> filename="important_data_file"
	> mv $filename $filename001
	
because the shell will treat $filename001 as a distinct variable name. You need to be explicit about where the variable name ends and the string begins. Double-quotes will work here, and so will curly braces:
	
	> mv "$filename" "$filename"001
	> mv "$filename" "${filename}001"
	
which are much clearer and can also be used to surround *all* variable names, not just where you want to avoid ambiguity.
    
This brings me to...
	
Tab Completion
--------------
Use it! In addition to saving keystrokes, the context-awareness of tab completion can help keep you from making tyops and from running commands from the wrong location. Taking the previous cd example, we could do

    > cd /Lib[Tab]
    
and bash will auto-complete that to

    > cd /Library/
    
Then we can type 'App' and hit tab
 
	> cd /Library/App[Tab]
	
and we get

	> cd /Library/Application\ Support/
	
Note how the shell automatically escapes the space for you.
	
If you type in some characters with no match, you'll see a terminal alert/flash letting you know that file does not exist in the current location. If the file or directory *is* there -- and there is more than one file that begins with those characters -- then bash will auto-complete your characters up to the point of ambiguity and flash the terminal. Hitting Tab a second time will show you all the files/directories that start with those letters. For example:

	> cd /Library/Col[tab]
	
will give you the following, plus a flash:

	> cd /Library/Color

Pressing tab again will give you

	> cd /Library/Color[tab]
	ColorPickers/ ColorSync/
	
Now you can add a 'P' or 'S' and hit Tab to auto-complete the rest of the path that you want.

Becuase of the possible ambiguity of the terminal alert when using tab completion, I've gotten into the habit of pressing Tab at least twice (like an elevator call button) so I know if I have zero or multiple matches.

Shell Expansion
---------------
The most common form of shell expansion you'll encounter in shell scripting is command subsitution. You'll end up using this constantly. There are two ways to do command substitution: by surrounding the shell command with backticks, e.g.

    `some command`

or with a dollar sign and parentheses, e.g.

	$(some command)
	
When the shell encounters these, it executes the command and substitutes its result into the script at that location. I prefer the latter form, since you don't need to escape special characters any differently than you would in a normal command.

You can also perform basic arithmetic with bash by using double parentheses like this:

	> num1=10
	> num2=6
    > echo $(( $num1 * $num2 / 3 ))
    20

Input, Output, Pipes
--------------------
Some common command formats:

    command [-option] [arguments]

e.g.
    
    grep -r Keynote /var/log/
    
----

    command [-option] [arguments] > [output file]
    
e.g.

    grep -r Keynote /var/log/ > ~/keynote_logs.txt
    
----
    
    command [-option] [arguments] | command [-option] [arguments] | ...
    
e.g.

    last | awk '{print $1}' | sort -u
    
What is a pipe? A pipe takes the output of the command to its left and gives it to the command to its right as input. If you think of a pipe as a funnel, with outputs always flowing downward, the last command above would look like this:

                                                 last
                                                 ----
                                                  \/
    awk '!/wtmp|reboot|root|shutdown/ {print $1}' __
    ------------------------------------------------
                          \/
                  sort -u __

Variables in Context
--------------------
Variables are your friend. Use them to save space and make your code easier to follow. I'll use a concrete example that will help me segue into the next section about Awk.

This command will list your network interfaces:

    networksetup -listnetworkserviceorder

This command uses awk to filter the results of the above command to show only the name of your primary network interface:

    networksetup -listnetworkserviceorder | awk -F'\\) ' '/\(1\)/ {print $2}'
    
I want to change my primary network interface's dns servers. I'll use shell expansion to assign the results of the above command to a variable that I can easily refer to it in another command:

    mainInt=$(networksetup -listnetworkserviceorder | awk -F'\\) ' '/\(1\)/ {print $2}')

Now I can use $mainInt in another command:

    networksetup -setdnsservers "$mainInt" 10.0.0.11 10.0.0.12
    
Notice that, since interface names often have spaces in them, I quoted "$mainInt" so it will be treated as a single argument.

Awk
---
Awk is a powerful text search and text-processing language. By default, it breaks down input by whitespace and assigns resulting ***words*** into numbered variables. $0 is the entire result, $1 is the first word, $2 is the second word, etc. Any manipulation you want to do with the awk command is put into curly brackets and separated by semicolons.

Awk has great bang-for-the-buck. You can use it instead of grep.

There are many great resources online to help you learn awk, so I won't go into too much detail here, but I will cover what I feel are some "killer features".

Let's examine the awk command I showed you in the previous section.

    awk -F'\\) ' '/\(1\)/ {print $2}'

Breaking it down into its components, we have the following segments:

    -F'\\) '

The -F option tells awk that you want to use a custom character or characters as **field delimiters**. In this case, I want awk to use a closing parenthesis followed by a space to delimit fields — ") ". (Note that the closing parenthesis needs to be double-escaped.) If you're using more than one consecutive character as a delimiter, the characters must be enclosed in single quotes. *Including* a space in your delimiter is a handy way of *excluding* that space from your results."

    /\(1\)/

Anything you want awk to search for goes inside a pair of forward slashes. This is awk's search field, and it supports regular expressions. This section tells awk that you want it to return only lines containing "(1)". (You need to escape the parentheses.) In this example, we're looking at the first line only: "(1) Built-in Ethernet". Now, moving within the curly brackets, we have...

    print $2

This tells awk to return the second field of the line. Since we used ") " as our delimiter, the second field will be everything after the ") " on the line that contains "(1)".

Also, note that the search portion and the command portion are enclosed in single quotes. The entire awk command turns the complete output of the 'networksetup -listnetworkserviceorder' command

    (1) Built-in Ethernet
    (Hardware Port: Ethernet, Device: en0)

    (2) AirPort
    (Hardware Port: AirPort, Device: en1)

    (3) Built-in FireWire
    (Hardware Port: FireWire, Device: fw0)

    (4) Bluetooth
    (Hardware Port: Bluetooth, Device: Bluetooth-Modem)

into a string corresponding to the primary network interface's name

    Built-in Ethernet
    
So, in summary, awk helped us get only the relevant portion of a specific line of the output of another command.

Regular Expressions
-------------------
A regular expression is just a sequence of characters that forms a search pattern. They can be hugely powerful and frustrating. You'll encounter them in the shell (paired with tools such as grep, sed, and awk) and in almost every programming language out there, so there are a few basics you should be familiar with.

**Asterisk**

The asterisk is a "greedy" wildcard search character that will match zero or more instances of the character preceding it.

	/fa*e/
	
will not match face, fame, or fake, as you might think. Remember that the asterisk refers to the preceding character, so this will match fae, faae, or faaaaaae.

**Period**

A period matches exactly one character.

	/fa.e/
	
would match face, fade, and fake, but not farce.

**Question Mark**

The question mark follows a character that may or may not be present.

	/far?ce/
	
would match color and colour.

**Plus**

The plus sign follows a character that you want to match one or more times.

	/lol+/
	
would match lol, loll, and lollllllll.

**Anchors**

If you know the thing you're looking for occurs at the beginning or the end of a line, use anchors.

^foo : will look for 'foo' at the beginning of a line

foo$ : will look for 'foo' at the end of a line

^foo$ : will look for a line that contains only 'foo'

**Character Sets**

To list a group of characters that you want to match *any* one of, use square brackets.

	/[aeiou]/  /[AEIOU]/  /[aeiouAEIOU]/
	
The first matches all lowercase vowels, the seconds matches uppercase vowels, and the third matches all vowels.

**Negated Sets**

You can negate a character set by putting a caret as the first character in the set.

	/[^aeiou]/
	
will match all non-vowel characters.


Sed (not covered in talk)
-------------------------
Sed is a "stream" editor, meaning it operates on text you "stream" to it. The feature I use most is the search-replace function.

Say you have a file named short_story.txt that contains the following:

	My favorite color is blue.
	I once had a yellow car, but I wished it were blue.

If your favorite color is now green, you could use sed to change how the file reads:

	> sed 's/blue/green/g' short_story.txt
	My favorite color is green.
	I once had a yellow car, but I wished it were green.
	
This does not actually change the contents of the file.


I/O Redirection (not covered in talk)
-------------------------------------
Another important shell feature to know is I/O redirection. You probably already know that to send a command's output to a file, you use the right angle bracket '>'. Using one bracket will overwrite any file of the same name. If you want to append, use double-brackets '>>'.

Here's something else you can do with I/O redirection that can come in very handy in scripts:

    cat << EOF > /some/file.txt
    This multi-line content will be written
    to /some/file.txt exactly as it is shown
    here. To signal the end of the text I want
    written to the file, I add the word 'EOF'
    on a line by itself after my content.
    EOF
    
This example uses a bash feature called a 'Here Document', or 'heredoc', which tells the shell to treat certain lines as if they were a separate file. This becomes even more powerful when you combine it with variables. In this example, I'm appending two entries to my hosts file for Active Directory servers, so that if DNS is ever down I can still reach them by hostname.

	ad_server1=$(host ad1.example.com | awk '{print $NF}')
	ad_server2=$(host ad2.axample.com | awk '{print $NF}')
    
    cat << EOF >> /etc/hosts
    $ad_server1    ad1.example.com ad1
    $ad_server2    ad2.example.com ad2
    EOF
    
You could also accomplish this with two echo commands:

    echo "$ad_server1  ad1.example.com ad1" >> /etc/hosts
    echo "$ad_server2  ad2.example.com ad1" >> /etc/hosts
    
Use whichever you prefer. I tend to use cat for multiple lines where I want to maintain formatting and line breaks, and echo whenever I'm only adding a single line.

I also want to point out the awk command I used here. As I explained before, awk splits lines up into fields by whitespace. NF is a special variable in awk that holds the **Number of Fields** in the current record. When used in conjunction with a dollar sign and print, awk returns the last field. This is very handy when you either don't want to count the number of fields or you don't know the number of fields ahead of time but know you want the last one. If you want the second to last field, awk lets you use math to accomplish it:

	some command | awk '{print $(NF-1)}'


Conditional Expressions
-----------------------
Sometimes you need to do one thing if a certain condition is met, and another thing if the condition is NOT met. To test these conditions, you use square brackets. Anything you put inside square brackets is treated as a true-or-false test. To specify what happens when it returns true or false, you use 'if/elif/else'. Here are some of the ways you can test conditions:

**Integer Comparisons**

-eq: is equal to

	[ "$a" -eq "$b" ]
	
-ne: is not equal to

	[ "$a" -ne "$b" ]
	
-gt: is greater than

	[ "$a" -gt "$b" ]
	
-ge: is greater than or equal to

	[ "$a" -ge "$b" ]
	
-lt: is less than

	[ "$a" -lt "$b" ]
	
-le: is less than or equal to

	[ "$a" -lt "$b" ]
	
**String Comparisons**

= or ==: is equal to

	[ "$a" = "$b" ]
	[ "$a" == "$b" ]
	
!=: is not equal to

	[ "$a" != "$b" ]
	
<: is less than (alphabetically) -- note the use of double-brackets

	[[ "$a" < "$b" ]]

\>: is greater than (alphabetically) -- note the use of double-brackets

	[[ "$a" > "$b" ]]
	
-n: string is not null, or empty (zero length)

	[ -n "$variable" ]
	
-z: string is null or empty (zero length)

	[ -z "$variable" ]

**File Tests**

If you are working with files and need to test whether a file exists or has certain characteristics, you can use the following:

-a: true if file exists

-d: true if file is directory

-h: true if file is symbolic link

-s: true if file is not empty

-r: true if file is readable

-w: true if file is writeable

-x: true if file is executable

All of these are used like this:

	[ -a FILE ]

**Examples**

The simplest form of a conditional statements looks like this:

	if [ conditional expression ]; then
		do A
	fi
	
If statements can also be written on one line by adding semicolons in the right places:

	if [ 1 -eq 1 ]; then echo "That is true."; fi
	
If blocks are always terminated by 'fi'. That's just how it is.
	
You'd use this if you only wanted your script to do something if a condition is met. If the condition is unmet, the 'do something' part will be ignored. The following format adds another layer of logic:

	if [ conditional expression ]; then
		do A
	else
		do B
	fi
	
In this example, the script does A if the conditional expression is true, or B if it is false. Sometimes you need to capture more complex situations. That's where the elif statement comes into play. It allows you to add any number of conditional expressions into your if statement.

	if [ conditional expression 1 ]; then
		do A
	elif [ conditional expression 2 ]; then
		do B
	elif [ conditional expression 3 ]; then
		do C
	else
		do D
	fi

Here's a real world example of an if statement that performs one action if the system is running Mavericks or newer, and another action if it is running Mountain Lion or older.

    os_dot_version=$(sw_vers -productVersion | awk -F. '{print $2}')
    
    if [ "$os_dot_version" -gt 8 ]; then
        echo "Cats are overrated."
    else
    	echo "I don't go outside."
    fi
    
Loops
-----
A loop is a block of code that repeats a list of commands. The most commonly used loop is the for loop. You use it when you want to perform the same action or series of actions on multiple items. A typical for loop looks like this:

	for item in (group of items); do
		something to each $item
	done
	
Note that a for loop closes with 'done' and not 'rof'. The 'item' word can be anything you want. On each iteration of the loop, the $item variable represents the current item in the group of items. The loop runs once per item in the group of items. Let's dive in a little bit with a simple example:

	fruits="apple
	banana
	cantaloupe
	durian"
	
	count=0
	for fruit in $fruits; do
		(( count++ ))
		echo "${count}: $fruit"
	done
	
This will output a numbered list of fruits. Ok, so this is a bit abstract. How about a real-world example? Let's say you want to clear a shared computer of local home directories and accounts belonging to all users *except* a couple that you want to keep?

	#!/bin/bash

	# Check if running as root
	if [ "$(id -u)" -ne "0" ]; then
    	echo "This script must be run as root."
    	exit 1
	fi

	# define users to keep in an array
	# (use spaces between items)
	KEEPERS=( administrator Shared )

	# iterate through list of folders in /Users
	for folder in /Users/*; do
    	# remove the "/Users/" portion of the path for easier testing
    	user=$(basename ${folder})
    	# compare folder name against the array items
    	if [[ "${KEEPERS[*]}" =~ "${user}" ]]; then
        	# skip if folder is in the skip array
        	echo "Skipping ${user}..."
    	else
        	# proceed with removal
        	echo "Removing ${user}..."
        	dscl . -delete /Users/${user}
        	rm -rf /Users/${user}
    	fi
	done

BONUS: Aliases and Functions
----------------------------
In this extra section I'll introduce a couple convenient ways to customize your shell environment.

An alias is a shortcut you define that runs a short command (with optional pre-defined options) whenever you type the shortcut. While  you can define an alias or function at any time by typing one into the shell, those will only last for the duration of your session. To make an alias or function permanent, you have to add it to you bash profile, which is stored in the ~/.profile file.

Open the hidden file in your favorite text editor (I use vim). You can structure your profile however you like, but I like to keep mine organized by adding headers and grouping the lines I add to it my type.

Let's create an alias for system_profiler called 'spl' that lists the available data types:

	alias spl='system_profiler -listDataTypes'
	
When I save the .profile file and then type 'spl', I get a 'command not found' error. I just edited my profile, so what's up? Well, .profile is only loaded when my sessions starts, so I need to tell bash to re-load the file. I do that by 'sourcing' it:

	source ~/.profile
	
Now the new alias should run.

The main difference between an alias and a function is that a function can read input from the command line and use it to alter the behavior of the command. Let's stick with system_profiler and create a function that makes it easier to show a specific data type. Normally, to show information about installed memory, you'd need to do something like this:

	system_profiler -listDataTypes # to remind yourself what the Displays data type is called
	system_profiler SPMemorysDataType
	
I want to create a function 'sp' that lets me do the following to get the same information:

	sp Memory
	
Bash functions all have the same basic format:

	name () { one or more commands here; }
	
You have the name, a pair of empty parentheses, and some commands surrounded by curly braces, with a semicolon at the end.

If you want your function to take input, you can refer to the input using numbered variables (i.e. $1, $2, etc, referring to each argument in the order it was passed) or use $@ to capture all arguments. Functions are quick-and-dirty things, so I usually use $@ and don't worry about parsing the info passed to tthem. So, let's open up my .profile and try writing the function. Notice how all the possible system_profiler data types start with 'SP' and end with 'DataType', and only differ by what's between those? This will help us craft the function. We just need to take our input and shove it in between those.

	sp () { system_profiler SP$@DataType; }
	
This will probably work, but see how the $@ gets lost in there? In addition to looking bad, it can actually cause some problems if you're not using a special built-in variable. We want to make sure the shell knows to interpret $@ as the variable name and not $@DataType. We can make the boundary between the variable and other stuff explicit by using curly braces around it:

	sp () { system_profiler SP${@}DataType; }
	 
Now we should be good to go.


