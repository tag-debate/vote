module tests::wallet_test {
    use 0x1::Test;
    use 0x1::Signer;
    use wallet::{Voter, Candidate, Admin, vote, increment_vote, withdraw_commission, update_candidate_info};

    public fun test_voting_functionality() {
        let admin_address = @0xA550C18;
        let voter_address = @0x1;
        let candidate_id = 1;
        let current_time = 1700000000;
        let voting_deadline = 1700100000;
        
        // Test setup: Create voter and candidate
        let mut voter = Voter { voted: false, vote_time: 0 };
        let mut candidate = Candidate { name: b"John Doe", photo_url: b"https://example.com/photo.jpg", vote_count: 0 };

        // Ensure the voter has not voted yet
        assert!(voter.voted == false, 1001);

        // Test: Successful vote before the deadline
        vote(candidate_id, &mut voter, current_time, voting_deadline);
        assert!(voter.voted == true, 1002); // Voter status should now be true (voted)
        assert!(voter.vote_time == current_time, 1003); // Vote time should be updated

        // Test: Candidate's vote count incremented
        increment_vote(candidate_id);
        assert!(candidate.vote_count == 1, 2001); // Vote count should be incremented to 1

        // Test: Trying to vote again should fail
        Test::expect_abort(1002, vote(candidate_id, &mut voter, current_time, voting_deadline));

        // Test: Voting after the deadline should fail
        let past_deadline_time = 1700200000;
        Test::expect_abort(1001, vote(candidate_id, &mut voter, past_deadline_time, voting_deadline));
    }

    public fun test_admin_functions() {
        let admin_address = @0xA550C18;
        let candidate_id = 1;
        let new_name = b"Jane Doe";
        let new_photo_url = b"https://example.com/new_photo.jpg";

        let mut admin = Admin { admin_address };
        let mut candidate = Candidate { name: b"John Doe", photo_url: b"https://example.com/photo.jpg", vote_count: 0 };

        // Test: Admin updates candidate information
        update_candidate_info(&admin, candidate_id, new_name, new_photo_url);
        assert!(candidate.name == new_name, 3001); // Name should be updated
        assert!(candidate.photo_url == new_photo_url, 3002); // Photo URL should be updated
    }

    public fun test_commission_withdrawal() {
        let admin_address = @0xA550C18;
        let commission_amount = 100;

        let mut admin = Admin { admin_address };

        // Test: Withdraw commission successfully
        withdraw_commission(&admin, commission_amount, admin_address);

        // Test: Unauthorized withdrawal attempt should fail
        let unauthorized_address = @0xBEEF;
        Test::expect_abort(1003, withdraw_commission(&admin, commission_amount, unauthorized_address));
    }

    #[test]
    public fun run_all_tests() {
        test_voting_functionality();
        test_admin_functions();
        test_commission_withdrawal();
    }
}