module CampaignFinance {

    /// Struct that defines a campaign's financial information
    struct Campaign {
        total_funds: u64,
        funding_limit: u64,
        traceable: bool
    }

    /// Struct that stores commission information
    struct Commission {
        admin: address,
        commission_amount: u64
    }

    /// Initialize a campaign with traceable finance and set funding limits
    public fun initialize_campaign(admin: address, funding_limit: u64, traceable: bool) acquires Campaign {
        assert!(funding_limit > 0, 1001, "Funding limit must be greater than 0.");
        move_to<Campaign>(admin, Campaign { total_funds: 0, funding_limit, traceable });
    }

    /// Add funds to the campaign, respecting the funding limit
    public fun add_funds(admin: &mut Campaign, amount: u64) acquires Campaign {
        let campaign = borrow_global_mut<Campaign>(admin);
        let new_total_funds = campaign.total_funds + amount;
        assert!(new_total_funds <= campaign.funding_limit, 1002, "Funding limit exceeded.");
        campaign.total_funds = new_total_funds;
    }

    /// Withdraw commission for an admin
    public fun withdraw_commission(admin: &mut Commission, amount: u64) acquires Commission {
        let commission = borrow_global_mut<Commission>(admin);
        assert!(commission.commission_amount >= amount, 1003, "Insufficient commission balance.");
        commission.commission_amount = commission.commission_amount - amount;
        move_to(admin, amount);
    }

    /// Enable traceability for campaign finance
    public fun enable_traceability(admin: address) acquires Campaign {
        let campaign = borrow_global_mut<Campaign>(admin);
        campaign.traceable = true;
    }

    /// Disable traceability for campaign finance
    public fun disable_traceability(admin: address) acquires Campaign {
        let campaign = borrow_global_mut<Campaign>(admin);
        campaign.traceable = false;
    }

    /// Function to transfer funds between campaigns
    public fun transfer_funds(from_campaign: &mut Campaign, to_campaign: &mut Campaign, amount: u64) acquires Campaign {
        assert!(from_campaign.total_funds >= amount, 1004, "Insufficient funds in the source campaign.");
        from_campaign.total_funds = from_campaign.total_funds - amount;
        to_campaign.total_funds = to_campaign.total_funds + amount;
    }

    /// View campaign funds
    public fun view_funds(admin: &Campaign): u64 {
        let campaign = borrow_global<Campaign>(admin);
        return campaign.total_funds;
    }

}