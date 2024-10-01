module Wallet {
    // Struct to represent a Voter
    struct Voter {
        voted: bool,       // Whether the voter has already voted
        vote_time: u64      // Timestamp of when the voter cast their vote
    }

    // Struct to represent a Candidate
    struct Candidate { 
        name: vector<u8>,   // Candidate's name
        photo_url: vector<u8>, // Candidate's photo URL
        vote_count: u64     // Number of votes received by the candidate
    }

    // Struct to represent an Admin
    public struct Admin {
        admin_address: address // Admin's address
    }

    // Function to allow voting with a timestamp check for deadlines
    public fun vote(
        candidate_id: u64, 
        voter: &mut Voter, 
        current_time: u64, 
        voting_deadline: u64
    ) acquires Voter {
        assert!(current_time <= voting_deadline, 1001, "Voting period is over.");
        assert!(!voter.voted, 1002, "Voter has already voted.");
        voter.voted = true;
        voter.vote_time = current_time;
        increment_vote(candidate_id);
    }

    // Function to increment the vote count for a candidate
    public fun increment_vote(candidate_id: u64) acquires Candidate {
        let candidate = borrow_global_mut<Candidate>(candidate_id);
        candidate.vote_count = candidate.vote_count + 1;
    }

    // Function to withdraw commission separately
    public fun withdraw_commission(
        admin: &Admin, 
        commission_amount: u64, 
        admin_address: address
    ) {
        assert!(admin.admin_address == admin_address, 1003, "Unauthorized access.");
        move_to(admin_address, commission_amount);
    }

    // Admin function to update candidate information (name and photo)
    public fun update_candidate_info(
        admin: &Admin, 
        candidate_id: u64, 
        new_name: vector<u8>, 
        new_photo_url: vector<u8>
    ) acquires Candidate {
        let candidate = borrow_global_mut<Candidate>(candidate_id);
        candidate.name = new_name;
        candidate.photo_url = new_photo_url;
    }
}