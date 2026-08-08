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
    price_point NUMERIC(10, 2) NOT NULL,
    transaction_type TEXT NOT NULL, -- e.g., 'IN' or 'OUT'
    total_value NUMERIC(10, 2) GENERATED ALWAYS AS (quantity * price_point) STORED, 
    user_id UUID REFERENCES auth.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Expenses 
CREATE TABLE public.expenses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    description TEXT NOT NULL,
    category TEXT NOT NULL, -- Added to support UI categories (Utilities, Salary, etc)
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

-- 6. Insert Starter Data (Optional but helps testing the UI immediately)
INSERT INTO public.inventory_items (name, price_point, category) VALUES 
('Tomato Paste (Large)', 15.50, 'Ingredients'),
('Cooking Oil (5L)', 45.00, 'Ingredients'),
('Flour (50kg)', 120.00, 'Ingredients'),
('Coca Cola (Crate)', 25.00, 'Beverages');