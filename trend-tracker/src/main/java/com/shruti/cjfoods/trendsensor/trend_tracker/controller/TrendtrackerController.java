package com.shruti.cjfoods.trendsensor.trend_tracker.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/trends")
@CrossOrigin(origins = "*")
public class TrendtrackerController {

   @GetMapping("/global")
public List<Map<String, Object>> getTrends() {
    return List.of(
        // GSP 1: Mandu (CJ's #1 Global Product)
        Map.of(
            "category", "GSP: Mandu",
            "trend_item", "Truffle Cream Mini-Mandu",
            "market_fit", "North America / Premium",
            "growth_rate", "114%",
            "sentiment", "High - Driven by 'Easy Gourmet' TikTok trend"
        ),
        // GSP 2: K-Sauce (CJ's focus on "Gochujang-everywhere")
        Map.of(
            "category", "GSP: K-Sauce",
            "trend_item", "Gochujang Hot Honey",
            "market_fit", "Europe / Gen-Z",
            "growth_rate", "89%",
            "sentiment", "Positive - Swicy (Sweet & Spicy) flavor profile surge"
        ),
        // GSP 3: P-Rice (Hetbahn expansion)
        Map.of(
            "category", "GSP: Processed Rice",
            "trend_item", "Multigrain Seaweed Risotto",
            "market_fit", "Global / Health-Conscious",
            "growth_rate", "45%",
            "sentiment", "Steady - Alignment with 'Vegan-friendly' labels"
        )
    );
}
@GetMapping("/recommendation/{item}")
public Map<String, String> getMarketingAction(@PathVariable String item) {
    if (item.contains("Mandu")) {
        return Map.of(
            "Action", "Increase Retail Presence (Costco/Walmart)",
            "Strategy", "Launch 'Bite-Sized' Campaign for school lunchboxes",
            "Priority", "Critical"
        );
    }
    return Map.of("Action", "Monitor Social Sentiment", "Strategy", "Seed products to micro-influencers");
}
}
