module MyModule::WorkersComp {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Stores worker details
    struct Worker has key, store {
        total_paid: u64,   // Total compensation paid
        salary: u64,       // Fixed salary amount
    }

    /// Register a worker with a salary
    public fun register_worker(employer: &signer, salary: u64) {
        let worker = Worker {
            total_paid: 0,
            salary,
        };
        move_to(employer, worker);
    }

    /// Pay compensation to worker
    public fun pay_worker(employer: &signer, worker_addr: address) acquires Worker {
        let worker = borrow_global_mut<Worker>(worker_addr);

        // Withdraw salary from employer’s account
        let payment = coin::withdraw<AptosCoin>(employer, worker.salary);
        coin::deposit<AptosCoin>(worker_addr, payment);

        // Update worker’s record
        worker.total_paid = worker.total_paid + worker.salary;
    }
}
