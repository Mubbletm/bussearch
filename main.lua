-- Instantiate variables
local query = get("query");
local btn = get("search-button")
local rndmbtn = get("random-button")

local items = get("item", true);
local itemName = get("item-name", true);
local itemUrl = get("item-url", true);
local itemIp = get("item-ip", true);

-- Fetch data
local response = fetch({
    url = "https://api.buss.lol/domains",
    method = "GET",
    headers = { },
    body = ""
});

-- Main thread
function main()
    clearItems();
end

-- Declare functions
------------------------------------
-- Clears all items from the results.
function clearItems()
    for index, item in pairs(items) do
        item.set_opacity(0);
    end
end

-- Displays the given item at the given index in the results.
function displayItem(index, item)
    local itemEl = items[index];
    local nameEl = itemName[index];
    local ipEl = itemIp[index];
    local urlEl = itemUrl[index];

    local url = "buss://" .. item["name"] .. "." .. item["tld"];

    itemEl.set_opacity(1);
    nameEl.set_content(item["name"]);
    ipEl.set_content(item["ip"]);
    urlEl.set_content(url);
    urlEl.set_href(url);
end

-- Displays an array of items in the results.
function displayItems(arr)
    clearItems();
    for index, item in pairs(arr) do
        displayItem(index, item)
    end
end

-- Filters all the items for items that match the given query string.
function filterItems(queryString)
    local filtered = {};
    for index, item in pairs(response) do
        local url = (item["name"] .. "." .. item["tld"]);
        if string.find(string.lower(url), string.lower(queryString)) then
            table.insert(filtered, item);
        end
    end
    return filtered;
end

-- Returns a random item from the list of items.
function getRandomItem()
    return response[math.random(#response)];
end

-- Retrieve the contents of the input and apply the query.
function applyQuery(queryString)
    displayItems(filterItems(query.get_content()));
end

-- Event Listeners
query.on_submit(applyQuery);
btn.on_click(applyQuery);
rndmbtn.on_click(function()
    clearItems();
    displayItem(1, getRandomItem());
end)

-- Run main thread
main();
