# Ruby Stack: Security Rules (secure-code)

## 1. Strong Parameters & Mass Assignment
- Never permit entire request parameter hashes (`params.permit!`).
- Explicitly whitelist expected scalar parameters using `params.require(:model).permit(:name, :email)`.

## 2. SQL Interpolation in ActiveRecord
- Avoid string interpolation in ActiveRecord queries:
  - ❌ `User.where("name = '#{params[:name]}'")`
  - 🛡️ `User.where("name = ?", params[:name])` or `User.where(name: params[:name])`

## 3. Safe Deserialization
- Never call `Marshal.load()` or `YAML.load()` on untrusted input. Use `JSON.parse()` or `YAML.safe_load()`.
- Use `Rack::Utils.secure_compare(a, b)` for constant-time comparisons.
