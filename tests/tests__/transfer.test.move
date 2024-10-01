module tests::transfer_test {
    use 0x1::Test;
    use 0x1::Account;
    use 0x1::Coin;
    use 0x1::CampaignFinance;
    use 0x1::Voting;
    use 0x1::ZKProofs;
    use 0x1::TransferModule;

    // Testando a funcionalidade de transferência de tokens de votação e fundos de campanha
    public fun test_transfer_voting_tokens() {
        // Criando contas fictícias para o teste
        let sender = Account::create();
        let recipient = Account::create();

        // Definindo a quantidade de tokens de voto e fundos de campanha
        let vote_token_amount = 100;
        let finance_amount = 500;

        // Gerando uma zk-proof válida para o teste
        let proof = ZKProofs::create_proof(sender, recipient, vote_token_amount, finance_amount);

        // Executando a função de transferência de tokens de votação
        TransferModule::transfer_voting_tokens(&sender, recipient, vote_token_amount, finance_amount, proof);

        // Validando os saldos após a transferência
        let sender_balance = Coin::balance(sender);
        let recipient_balance = Coin::balance(recipient);
        Test::assert(sender_balance == 900, 1001, "Saldo do remetente incorreto após a transferência.");
        Test::assert(recipient_balance == 100, 1002, "Saldo do destinatário incorreto após a transferência.");

        // Validando o saldo de fundos de campanha
        let sender_finance_balance = CampaignFinance::balance(sender);
        let recipient_finance_balance = CampaignFinance::balance(recipient);
        Test::assert(sender_finance_balance == 500, 1003, "Saldo do remetente para fundos de campanha incorreto.");
        Test::assert(recipient_finance_balance == 500, 1004, "Saldo do destinatário para fundos de campanha incorreto.");
    }

    // Testando a falha na transferência devido a saldo insuficiente
    public fun test_transfer_insufficient_balance() {
        let sender = Account::create();
        let recipient = Account::create();
        let vote_token_amount = 1100; // Quantidade maior que o saldo fictício de 1000
        let finance_amount = 500;

        let proof = ZKProofs::create_proof(sender, recipient, vote_token_amount, finance_amount);

        // Espera que a transferência falhe devido a saldo insuficiente
        Test::expect_abort(1002, TransferModule::transfer_voting_tokens(&sender, recipient, vote_token_amount, finance_amount, proof));
    }

    // Testando a falha na transferência devido a zk-proof inválida
    public fun test_transfer_invalid_proof() {
        let sender = Account::create();
        let recipient = Account::create();
        let vote_token_amount = 100;
        let finance_amount = 500;

        // Gerando uma zk-proof inválida
        let invalid_proof = ZKProofs::create_invalid_proof();

        // Espera que a transferência falhe devido a zk-proof inválida
        Test::expect_abort(1003, TransferModule::transfer_voting_tokens(&sender, recipient, vote_token_amount, finance_amount, invalid_proof));
    }
}