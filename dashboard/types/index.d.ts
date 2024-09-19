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
  updatedAt: Date; // JavaScript Date type for DateTime, automatically updated
}

// Example Enum definitions (You should update these based on your needs)
enum UserRole {
  admin = "admin",
  user = "user",
  guest = "guest",
}

enum UserStatus {
  pending = "pending",
  active = "active",
  inactive = "inactive",
}

enum Gender {
  man = "man",
  woman = "woman",
}
