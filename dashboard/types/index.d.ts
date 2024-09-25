declare interface Product {
  id: string;
  title: string;
  price: number;
  originalPrice: number | null;
  description: string | null;
  createdAt: Date;
  updatedAt: Date;
  barcode: string;
  image: string;
  categoryIDs: string[];
  categories?: Category[];
  brandIDs: string[];
  brands?: Brand[];
  skus: ColorDetails[];
}

declare interface Category {
  id: string;
  title: string;
  main: boolean;
  image?: string;
  brands?: Brand[];
  brandIds: string[];
  Product?: Product[];
  productIDs: string[];
}

declare interface Brand {
  id: string;
  title: string;
  image?: string;
  categoryIDs: string[];
  categories?: Category[];
  Product?: Product[];
  productIDs: string[];
}

declare interface ColorDetails {
  id: string; // Corresponding to @id and @db.ObjectId
  qty: number; // Corresponding to qty Int
  hashedColor?: string; // Corresponding to hashedColor String?
  nameOfColor?: string; // Corresponding to nameOfColor String?
  // size: string; // Corresponding to size String
  image?: string; // Corresponding to image String?
  product?: Product; // Corresponding to Product? relation
  productId?: string; // Corresponding to productId @db.ObjectId
}

declare interface User {
  id: string; // Corresponds to @db.ObjectId
  fullName: string;
  password: string;
  role: UserRole; // Enum type, you'll need to define this separately
  status: UserStatus; // Enum type, you'll need to define this separately
  gender: Gender; // Enum type, you'll need to define this separately
  companyTitle: string;
  location?: string; // Optional field
  mobile: number; // Unique field
  componeyMobile: number;
  createdAt: Date; // JavaScript Date type for DateTime
  updatedAt: Date; // JavaScript Date type for DateTime, automatically update
  orders: Order[];
  token?: string;
}

interface Order {
  id: string; // Unique identifier for the order
  userId?: string; // Optional ID of the associated user
  totalPrice: number; // Total price of the order
  rest: number; // Remaining amount for the order
  createdAt: Date; // Timestamp for when the order was created
  updatedAt: Date; // Timestamp for when the order was last updated
  orderItems: OrderItem[]; // Array of order items associated with the order
  user?: User; // Optional reference to the associated User object
  status: OrderStatus;
  barcode: string;
}

declare interface OrderItem {
  id: string; // Unique identifier for the order item
  productId: string; // ID of the product
  skuId: string; // Stock Keeping Unit ID
  barcode: string; // Barcode of the product
  qty: number; // Quantity of the item in the order
  title: string; // Title of the product
  image: string; // URL of the product image
  skuImage?: string; // Optional URL for SKU-specific image
  hashedColor?: string; // Optional hashed color code
  price: number; // Price of the item
  nameOfColor?: string; // Optional name of the color
  createdAt: Date; // Timestamp for when the item was added to the order
  updatedAt: Date; // Timestamp for when the item was last updated
  orderId?: string; // Optional ID of the associated order
  order?: Order; // Optional reference to the associated Order object
}

type UserRole = "admin" | "user" | "guest";

type UserStatus = "pending" | "active" | "inactive";

type Gender = "man" | "woman";

type OrderStatus = "pending" | "inProgress" | "done" | "rejected" | "refused";

declare interface UserSession {
  fullName: string;
  id: string;
  mobile: number;
  status: UserStatus;
  role: UserRole;
  token?: string;
}
