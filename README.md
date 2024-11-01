# Mastermind
Mastermind Game written in Ruby

This is an exercise from Ruby course at The Odin Project
https://www.theodinproject.com/lessons/ruby-mastermind

If you’ve never played Mastermind, it’s a game where you have to guess your opponent’s secret code within a certain number of turns (like hangman with colored pegs). Each turn you get some feedback about how good your guess was – whether it was exactly correct or just the correct color but in the wrong space.

Assignment
Build a Mastermind game from the command line where you have 12 turns to guess the secret code, starting with you guessing the computer’s random code.

Think about how you would set this problem up!
Build the game assuming the computer randomly selects the secret colors and the human player must guess them. Remember that you need to give the proper feedback on how good the guess was each turn!
Now refactor your code to allow the human player to choose whether they want to be the creator of the secret code or the guesser.
Build it out so that the computer will guess if you decide to choose your own secret colors. You may choose to implement a computer strategy that follows the rules of the game or you can modify these rules.
If you choose to modify the rules, you can provide the computer additional information about each guess. For example, you can start by having the computer guess randomly, but keep the ones that match exactly. You can add a little bit more intelligence to the computer player so that, if the computer has guessed the right color but the wrong position, its next guess will need to include that color somewhere.
If you want to follow the rules of the game, you’ll need to research strategies for solving Mastermind.
Post your solution below!

ONCE DONE THE GAME: 
In my game you can chosse between the player is the guesser or the AI is the guesser
What algorithm uses the AI?

The algorithm implemented here is far from optimal. It does solve the secret code, yes; but it takes many turns.
There are two reasons why this algorithm is not efficient:
1. Nobody wants to play against an AI that systematically solves a Mastermind board in five turns;
for the same reason that nobody plays tic-tac-toe against an artificial intelligence:
because, mathematically, it is impossible to beat.
With an inefficient algorithm, there is a chance that the computer will run out of turns before guessing the secret code.
2. I am not a mathematician or a software engineer.
I do not want to enter the deep world of artificial intelligence development right now.
Right now I am focused on learning how to build web applications, not on algorithms.
Perhaps, when Project Odin is over, I will review this code and develop a more efficient algorithm.
For now, I do not want to waste too many days on an exercise whose real objective is to learn how Object Orientation is applied, not algorithms.

My algorithm (which I will call "Miki algorithm" works like this):
I. PHASE ONE:
1. At the start of the game, the AI shuffles the six colors
2. One by one, the AI tries secuences of 4 identical colors, until it founds all the colors in the code.
If in the fifth trial the AI has not gather the 4 colors, it asummes that the chips left are of the sixth color
II. PHASE TWO:
1. When the AI knows the four colors but no the order, it calculates all the possible combinations and shuffles them
If there is a already tried combination, the AI elimites it from its memory
2. One by one, the AI tries these combinations
3. When the combination has 1 dead (correct color on the correct position), and there was not a 2 dead combination before,
the AI removes all the combinations that hasn't got at least one 1 dead coinciding, reducing the possible combinations
4. When the combination has 2 dead, the AI removes all the combinations that hasn't got at least one 1 dead coinciding,
reducing DRASTICALLY the possible combinations

ONCE TRIED THIS ALGORITHM, the results is:
1. If the combination has some repeated colors, it always guess the combination in 12 turns or less
2. If the combination has not repeated colors, it guess the combination in 12 turns or less MOST OF THE TIMES
So: it is difficult that the AI does not guess the code on time... but not impossible!
That makes the game much more interest than using a perfectly efficient algorithm
