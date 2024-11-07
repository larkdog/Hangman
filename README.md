# Hangman
## Jimmy Flanagan & Meris Larkins

To solve this problem, the main elements we used were a working red GUI, a wordlist, and a series of images that showed the status of the hangman game. 
“wordlist.txt” is a file containing almost 1500 7-letter words. The function “pick-word” picks a random word from this list and sets it as the word to be solved. This function also initializes this word as an array and initializes the number of guesses to be 6.

From here, the GUI can be displayed with the 7 empty underscores ‘_’ to represent the letters that must be guessed. From here a series of checking occurs to see if the letter exists in the letter/was already called. Then the entire GUI is updated accordingly. If the letter is correct, the underscore is replaced with the correct letter. If the letter is incorrect, the new image of the corresponding next step in hangman is loaded. For example, if it’s the first wrong guess, now a head would be displayed (just a circle). In order, the next images have body, left leg, right leg, left arm, right arm.
The game will end either when the user has guessed the correct word or when all guesses has been used and a man is now shown hanging!
