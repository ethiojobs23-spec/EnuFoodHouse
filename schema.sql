-- 1. Inventory Catalog (Pre-defined items)
CREATE TABLE public.inventory_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    price_point NUMERIC(10, 2) NOT NULL,
    category TEXT, -- e.g., 'Beverages', 'Ingredients'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Inventory Transactions (Recorded usage)
CREATE TABLE public.inventory_transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    item_id UUID REFERENCES public.inventory_items(id) ON DELETE CASCADE,
    quantity NUMERIC(10, 2) NOT NULL,
    -- NOTE: In order to use a generated column, price_point needs to be stored on this table as well.
    -- This is actually best practice because prices change over time, and you want to record the price at the time of transaction.
    price_point NUMERIC(10, 2) NOT NULL,
    total_value NUMERIC(10, 2) GENERATED ALWAYS AS (quantity * price_point) STORED, 
    user_id UUID REFERENCES auth.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Expenses 
CREATE TABLE public.expenses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    description TEXT NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    user_id UUID REFERENCES auth.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.inventory_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

-- 5. Create Policies (Only authenticated users can access)
CREATE POLICY "Allow authenticated full access to inventory_items" 
ON public.inventory_items FOR ALL TO authenticated USING (true);

CREATE POLICY "Allow authenticated full access to inventory_transactions" 
ON public.inventory_transactions FOR ALL TO authenticated USING (true);

CREATE POLICY "Allow authenticated full access to expenses" 
ON public.expenses FOR ALL TO authenticated USING (true);
