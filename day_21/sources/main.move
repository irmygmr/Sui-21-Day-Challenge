/// DAY 21: Final Tests & Cleanup
/// 
/// Today you will:
/// 1. Write comprehensive tests for the farm
/// 2. Clean up your code
/// 3. Review what you've learned
///
/// Note: You can copy code from day_20/sources/solution.move if needed

module challenge::day_21 {
    use sui::event;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::transfer;
    use std::vector;

    // Hata Kodları
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // --- Structlar ---

    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    public struct PlantEvent has copy, drop {
        planted_after: u64,
    }

    // --- Fonksiyonlar ---

    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = Farm {
            id: object::new(ctx),
            counters: new_counters(),
        };
        transfer::share_object(farm);
    }

    public entry fun plant_on_farm_entry(farm: &mut Farm, plotId: u8) {
        // Doğrulamalar
        assert!(plotId >= 1 && plotId <= (MAX_PLOTS as u8), E_INVALID_PLOT_ID);
        let len = vector::length(&farm.counters.plots);
        assert!(len < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
        
        let mut i = 0;
        while (i < len) {
            let existing_plot = vector::borrow(&farm.counters.plots, i);
            assert!(*existing_plot != plotId, E_PLOT_ALREADY_EXISTS);
            i = i + 1;
        };
        
        // İşlem
        farm.counters.planted = farm.counters.planted + 1;
        vector::push_back(&mut farm.counters.plots, plotId);

        // Event
        event::emit(PlantEvent {
            planted_after: farm.counters.planted,
        });
    }

    public entry fun harvest_from_farm_entry(farm: &mut Farm, plotId: u8) {
        let len = vector::length(&farm.counters.plots);
        let mut i = 0;
        let mut found_index = len; 

        while (i < len) {
            let existing_plot = vector::borrow(&farm.counters.plots, i);
            if (*existing_plot == plotId) {
                found_index = i;
            };
            i = i + 1;
        };
        
        assert!(found_index < len, E_PLOT_NOT_FOUND);
        
        vector::remove(&mut farm.counters.plots, found_index);
        farm.counters.harvested = farm.counters.harvested + 1;
    }

    // --- Sorgu Fonksiyonları ---

    public fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    public fun total_harvested(farm: &Farm): u64 {
        farm.counters.harvested
    }

    // ==========================================
    //                  TESTLER
    // ==========================================
    #[test_only]
    use sui::test_scenario;

    #[test]
    fun test_create_farm() {
        let addr = @0xA1;
        let mut scenario = test_scenario::begin(addr);
        
        create_farm(test_scenario::ctx(&mut scenario));

        test_scenario::next_tx(&mut scenario, addr);
        {
            let farm = test_scenario::take_shared<Farm>(&scenario);
            assert!(total_planted(&farm) == 0, 0);
            assert!(total_harvested(&farm) == 0, 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_planting_increases_counter() {
        let addr = @0xA1;
        let mut scenario = test_scenario::begin(addr);
        create_farm(test_scenario::ctx(&mut scenario));

        test_scenario::next_tx(&mut scenario, addr);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1);
            assert!(total_planted(&farm) == 1, 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_harvesting_increases_counter() {
        let addr = @0xA1;
        let mut scenario = test_scenario::begin(addr);
        create_farm(test_scenario::ctx(&mut scenario));

        test_scenario::next_tx(&mut scenario, addr);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1);
            harvest_from_farm_entry(&mut farm, 1);
            assert!(total_planted(&farm) == 1, 0);
            assert!(total_harvested(&farm) == 1, 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_multiple_operations() {
        let addr = @0xA1;
        let mut scenario = test_scenario::begin(addr);
        create_farm(test_scenario::ctx(&mut scenario));

        test_scenario::next_tx(&mut scenario, addr);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 3);
            plant_on_farm_entry(&mut farm, 5);
            plant_on_farm_entry(&mut farm, 18);
            harvest_from_farm_entry(&mut farm, 5);
            
            assert!(total_planted(&farm) == 3, 0);
            assert!(total_harvested(&farm) == 1, 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = E_INVALID_PLOT_ID)]
    fun test_invalid_plot_id_zero() {
        let addr = @0xA1;
        let mut scenario = test_scenario::begin(addr);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, addr);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 0); // Hata vermeli
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = E_PLOT_ALREADY_EXISTS)]
    fun test_duplicate_plot() {
        let addr = @0xA1;
        let mut scenario = test_scenario::begin(addr);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, addr);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1);
            plant_on_farm_entry(&mut farm, 1); // Hata vermeli
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = E_PLOT_LIMIT_EXCEEDED)]
    fun test_plot_limit() {
        let addr = @0xA1;
        let mut scenario = test_scenario::begin(addr);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, addr);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            let mut i = 1;
            // 20 adet farklı plot ekliyoruz (1'den 20'ye kadar)
            while (i <= 20) {
                plant_on_farm_entry(&mut farm, (i as u8));
                i = i + 1;
            };
            
            // ŞİMDİ: 21. plotu eklemeye çalışıyoruz. 
            // ID hatası almamak için geçerli bir ID (1-20 arası) veriyoruz, 
            // ama limit dolduğu için E_PLOT_LIMIT_EXCEEDED (2) hatası bekliyoruz.
            plant_on_farm_entry(&mut farm, 1); 
            
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }
    #[test]
    #[expected_failure(abort_code = E_PLOT_NOT_FOUND)]
    fun test_harvest_nonexistent_plot() {
        let addr = @0xA1;
        let mut scenario = test_scenario::begin(addr);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, addr);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            harvest_from_farm_entry(&mut farm, 10); // Hiç ekilmemiş plot hata vermeli
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }
}

    // TODO: Write comprehensive tests:
    // 
    // Test 1: test_create_farm
    // - Create a farm (shared object)
    // - Check initial counters are zero
    // - Use test_scenario::take_shared to get the farm
    // 
    // Test 2: test_planting_increases_counter
    // - Create farm, plant plotId 1
    // - Verify planted counter is 1
    // - Use test_scenario::take_shared and test_scenario::return_shared
    // 
    // Test 3: test_harvesting_increases_counter
    // - Create farm, plant plotId 1, then harvest plotId 1
    // - Verify both counters are 1
    // 
    // Test 4: test_multiple_operations
    // - Plant plotIds 3, 5, 18 (in any order)
    // - Harvest plotId 5
    // - Verify planted counter is 3, harvested counter is 1
    // 
    // Test 5: test_invalid_plot_id
    // - Try to plant plotId 0 or 21 (should abort)
    // 
    // Test 6: test_duplicate_plot
    // - Plant plotId 1, then try to plant plotId 1 again (should abort)
    // 
    // Test 7: test_plot_limit
    // - Try to plant 21 plots (should abort on the 21st)
    // 
    // Test 8: test_harvest_nonexistent_plot
    // - Try to harvest a plot that doesn't exist (should abort)
    // 
    // Use test_scenario::begin, test_scenario::next_tx, test_scenario::take_shared, etc.
    // Note: Since farm is a shared object, use test_scenario::take_shared instead of take_from_sender

    // TODO: Review all three projects (habit_tracker, bounty_board, farm_simulator)
    // Make sure function names are consistent
    // Remove any unnecessary comments
    // Ensure all tests pass

