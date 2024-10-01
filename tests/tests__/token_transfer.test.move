module tests::token_transfer_test {
    use 0x1::Account;
    use 0x1::Coin;
    use 0x1::Voting;
    use 0x1::STV;
    use 0x1::ZKProofs;
    use 0x1::CampaignFinance;
    use 0x1::Test;
    use 0x1::TokenTransfer;

    // Função de teste para verificar a transferência de tokens de votação
    public fun test_transfer_voting_tokens() {
        let sender = @0x1;
        let recipient = @0x2;
        let voting_token_amount = 100;
        let contribution_amount = 50;

        // Simulação de zk-proof válida para teste
        let proof = ZKProofs::create_proof(sender, recipient, voting_token_amount, contribution_amount);

        // Executa a função de transferência de tokens de votação
        TokenTransfer::transfer_voting_tokens(
            &sender,
            recipient,
            voting_token_amount,
            contribution_amount,
            proof
        );

        // Verifica se os tokens de votação foram transferidos corretamente
        let sender_balance = Voting::get_balance(sender);
        let recipient_balance = Voting::get_balance(recipient);
        Test::assert_equal(sender_balance, 900, "Saldo incorreto para o remetente após a transferência.");
        Test::assert_equal(recipient_balance, 100, "Saldo incorreto para o destinatário após a transferência.");

        // Verifica se os fundos de campanha foram transferidos corretamente
        let sender_finance = CampaignFinance::get_balance(sender);
        let recipient_finance = CampaignFinance::get_balance(recipient);
        Test::assert_equal(sender_finance, 950, "Saldo incorreto de fundos de campanha para o remetente após a transferência.");
        Test::assert_equal(recipient_finance, 50, "Saldo incorreto de fundos de campanha para o destinatário após a transferência.");
    }

    // Função de teste para verificar zk-proof inválida
    public fun test_invalid_zk_proof() {
        let sender = @0x1;
        let recipient = @0x2;
        let voting_token_amount = 100;
        let contribution_amount = 50;

        // Simulação de zk-proof inválida
        let invalid_proof = ZKProofs::create_invalid_proof();

        // Executa a função de transferência de tokens de votação com zk-proof inválida, esperando falha
        Test::expect_abort(1003, TokenTransfer::transfer_voting_tokens(
            &sender,
            recipient,
            voting_token_amount,
            contribution_amount,
            invalid_proof
        ));
    }

    // Função de teste para verificar saldo insuficiente de fundos de campanha
    public fun test_insufficient_funds() {
        let sender = @0x1;
        let recipient = @0x2;
        let voting_token_amount = 100;
        let contribution_amount = 1000; // Valor maior que o saldo disponível

        // Simulação de zk-proof válida para teste
        let proof = ZKProofs::create_proof(sender, recipient, voting_token_amount, contribution_amount);

        // Executa a função de transferência de tokens de votação, esperando falha por saldo insuficiente
        Test::expect_abort(1002, TokenTransfer::transfer_voting_tokens(
            &sender,
            recipient,
            voting_token_amount,
            contribution_amount,
            proof
        ));
    }
}