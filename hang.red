; SI413 Project Part 2
Red [
    needs: 'view
    Original-Author: Meris Larkins and Jimmy Flanagan
]

pick-word: function [] [
    ; pick random word from wordlist
    ; discard and choose again if word is empty
    forever [
        random/seed now
        wrd: pick wordlist random length? wordlist
        if (length? wrd) > 0 [break]
        clear wrd
    ]

    ; initialize hidden word and store in a file
    if not find read %. %chars.txt [
        chars: []
        clear chars
        loop length? wrd [insert chars "*"]
        save %chars.txt chars
    ]

    ; initialize number of guesses and store in a file
    if not find read %. %guesses.txt [
        guesses: 6
        save %guesses.txt guesses
    ]

    ; initialize array of letters guessed and store in a file
    if not find read %. %guessed-letters.txt [
        guessed-letters: []
        clear guessed-letters
        save %guessed-letters.txt guessed-letters
    ]

    return wrd
]

; convert a char series into a string with spaces
to-string: function [arr] [
    string: ""
    foreach c arr [
        append string c
        append string " "
    ]
    return string
    clear string
]

; convert a char series into a string without spaces
to-letters: function [arr] [
    s: ""
    foreach c arr [
        append s c
    ]
    return s
    clear s
]

; initialize data for GUI on startup
wordlist: read/lines %wordlist.txt
wrd: pick-word
chars: load %chars.txt
str: to-string chars
letters: ""
graphic: load %empty.png

view [ 
     title "Hangman"
     backdrop pink

     ; all GUI elements besides the text field and buttons
     panel [
        below
        img: image graphic
        text "Word:" font-size 24 white font-color green
        b: text 800 str font-size 24 white font-color black
        text "Guessed Letters:" font-size 24 white font-color green
        c: text 600 letters font-size 24 white font-color black
     ]

    ; text field
     below
     text "Type a letter:" font-size 18 white font-color green
     d: field 50 return

     button "Guess Letter" [
        ; load data from files into variables
        guessed-letters: load %guessed-letters.txt
        chars: load %chars.txt
        guesses: load %guesses.txt
        guess: (to-integer guesses)

        ; data sanitization
        either (length? d/text) > 1 [
            alert "One letter per guess!"

        ; no penalty if the letter was guessed already
        ][either find/case guessed-letters (to-char d/text) [
            alert "Letter already guessed!"

        ; letter found
        ][either find/case wrd (to-char d/text)[
            ; replace char in hidden word with found letter
            i: 1
            loop length? wrd [
                series: []
                insert series (pick wrd i)
                if find series (to-char d/text) [
                    poke chars i d/text
                ]
                i: i + 1
                clear series
            ]

            ; save data, update letters guessed,
            ; and update GUI elements accordingly
            save %chars.txt chars
            append guessed-letters d/text
            clear letters
            letters: to-letters guessed-letters
            c/text: letters
            clear str
            str: to-string chars
            b/text: str
            save %guessed-letters.txt guessed-letters
        ][
            ; incorrect guess: load next hangman graphic
            ; depending on guesses remaining
            guess: guess - 1
            if guess = 5 [
                graphic: load %one.png
                img/image: graphic
            ]
            if guess = 4 [
                graphic: load %two.png
                img/image: graphic
            ]
            if guess = 3 [
                graphic: load %three.png
                img/image: graphic
            ]
            if guess = 2 [
                graphic: load %four.png
                img/image: graphic
            ]
            if guess = 1 [
                graphic: load %five.png
                img/image: graphic
            ]
            if guess = 0 [
                graphic: load %six.png
                img/image: graphic
            ]

            ; update GUI and files
            save %guesses.txt guess
            append guessed-letters d/text
            clear letters
            letters: to-letters guessed-letters
            c/text: letters
            save %guessed-letters.txt guessed-letters
        ]]]

        i: 1
        counter: 0

        ; determine if the game has been won
        ; by comparing the hidden word to the real word
        loop length? wrd [
            series: []
            insert series (pick wrd i)
            if find/case series (to-char pick chars i) [
                counter: counter + 1
            ]
            i: i + 1
            clear series
        ]

        ; win/lose conditions
        if ((length? wrd) = counter) or (guess = 0) [
            if (length? wrd) = counter [
                alert "You win!"
            ]
            if guess = 0 [
                alert wrd
            ]
            ; remove temporary files until next game
            delete %chars.txt
            delete %guesses.txt
            delete %guessed-letters.txt

            ; pick new word, initialize new hidden word,
            ; and load empty noose image
            clear wrd
            wrd: pick-word
            clear str
            clear letters
            chars: load %chars.txt
            str: to-string chars
            graphic: load %empty.png
            img/image: graphic
        ]
        clear d/text
    ]

    button "Start Over" [
        ; remove temporary files until next game
        delete %chars.txt
        delete %guesses.txt
        delete %guessed-letters.txt

        ; pick new word, initialize new hidden word,
        ; and load empty noose image
        clear wrd
        wrd: pick-word
        clear str
        clear letters
        chars: load %chars.txt
        str: to-string chars
        graphic: load %empty.png
        img/image: graphic
    ]
]

; remove temporary files until next game
delete %chars.txt
delete %guesses.txt
delete %guessed-letters.txt