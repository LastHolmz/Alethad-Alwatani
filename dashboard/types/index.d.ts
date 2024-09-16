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
  sku: ColorDetails[];
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
  size: string; // Corresponding to size String
  image?: string; // Corresponding to image String?
  product?: Product; // Corresponding to Product? relation
  productId?: string; // Corresponding to productId @db.ObjectId
}
