function blackjackGUI()
    deck = shuffleDeck(createDeck());
    playerHand = deck(1:2);
    dealerHand = deck(3:4);
    deck(1:4) = [];

    fig = figure('Name', 'Blackjack 🃏', 'NumberTitle', 'off', ...
                 'Position', [200, 100, 700, 700], 'Color', [0.05 0.3 0.2]);

    uicontrol(fig, 'Style', 'text', 'Position', [250, 620, 200, 40], ...
              'String', '♠️ Blackjack Game ♥️', 'FontSize', 24, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.05 0.3 0.2], 'ForegroundColor', [1 1 1]);

    playerLabel = uicontrol(fig, 'Style', 'text', 'Position', [50, 500, 600, 30], ...
                            'String', ['Player Hand: ', num2str(playerHand)], 'FontSize', 16, ...
                            'FontWeight', 'bold', 'BackgroundColor', [0.05 0.3 0.2], ...
                            'ForegroundColor', [1 1 1]);

    dealerLabel = uicontrol(fig, 'Style', 'text', 'Position', [50, 460, 600, 30], ...
                            'String', 'Dealer Hand: [X, ?]', 'FontSize', 16, ...
                            'FontWeight', 'bold', 'BackgroundColor', [0.05 0.3 0.2], ...
                            'ForegroundColor', [1 1 1]);

    gameStatus = uicontrol(fig, 'Style', 'text', 'Position', [50, 420, 600, 30], ...
                           'String', 'Game Status: In Progress', 'FontSize', 16, ...
                           'FontWeight', 'bold', 'BackgroundColor', [0.05 0.3 0.2], ...
                           'ForegroundColor', [1 1 1]);

    uicontrol(fig, 'Style', 'pushbutton', 'Position', [100, 250, 120, 50], ...
              'String', 'Hit', 'FontSize', 16, 'FontWeight', 'bold', ...
              'Callback', @hitCallback, 'BackgroundColor', [0.9 0.3 0.3], ...
              'ForegroundColor', [1 1 1]);

    uicontrol(fig, 'Style', 'pushbutton', 'Position', [290, 250, 120, 50], ...
              'String', 'Stand', 'FontSize', 16, 'FontWeight', 'bold', ...
              'Callback', @standCallback, 'BackgroundColor', [0.3 0.3 0.9], ...
              'ForegroundColor', [1 1 1]);

    uicontrol(fig, 'Style', 'pushbutton', 'Position', [480, 250, 120, 50], ...
              'String', 'Play Again', 'FontSize', 16, 'FontWeight', 'bold', ...
              'Callback', @playAgainCallback, 'BackgroundColor', [0.3 0.8 0.3], ...
              'ForegroundColor', [1 1 1]);

    set(playerLabel, 'String', ['Player Hand: ', num2str(playerHand)]);
    set(dealerLabel, 'String', ['Dealer Hand: [', num2str(dealerHand(1)), ', ?]']);

    uiwait(fig);

    function hitCallback(~, ~)
        if calculateScore(playerHand) < 21
            playerHand = [playerHand, deck(1)];
            deck(1) = [];
            set(playerLabel, 'String', ['Player Hand: ', num2str(playerHand)]);
            if calculateScore(playerHand) > 21
                set(gameStatus, 'String', 'You busted! Dealer wins.');
            end
        end
    end

    function standCallback(~, ~)
        while calculateScore(dealerHand) < 17
            dealerHand = [dealerHand, deck(1)];
            deck(1) = [];
        end
        set(dealerLabel, 'String', ['Dealer Hand: ', num2str(dealerHand)]);
        determineWinner();
    end

    function playAgainCallback(~, ~)
        close(fig);
        blackjackGUI();
    end

    function determineWinner()
        playerScore = calculateScore(playerHand);
        dealerScore = calculateScore(dealerHand);
        if playerScore > 21
            set(gameStatus, 'String', 'You busted! Dealer wins.');
        elseif dealerScore > 21 || playerScore > dealerScore
            set(gameStatus, 'String', 'You win!');
        elseif playerScore == dealerScore
            set(gameStatus, 'String', 'It''s a tie!');
        else
            set(gameStatus, 'String', 'Dealer wins.');
        end
    end
end

function deck = createDeck()
    values = [1:10, 10, 10, 10];
    deck = repmat(values, 1, 4);
end

function deck = shuffleDeck(deck)
    deck = deck(randperm(length(deck)));
end

function score = calculateScore(hand)
    score = sum(hand);
    aces = sum(hand == 1);
    while score <= 11 && aces > 0
        score = score + 10;
        aces = aces - 1;
    end
end
