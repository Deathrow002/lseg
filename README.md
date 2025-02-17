
# AWS Instance Metadata Query Script

This script is designed to fetch metadata information from an AWS EC2 instance. It supports querying all metadata, specific keys, and nested sub-keys. The script gracefully handles both correct and incorrect key cases and provides JSON-formatted output.

---

## **Use Cases**

### 1. Fetch All Metadata  
Run the script without any arguments to retrieve all available metadata for the instance in JSON format.

```bash
./script_name.sh
```

#### Example Output:
```json
{
  "instance-id": "i-0123456789abcdef0",
  "local-ipv4": "192.168.1.100",
  "security-groups": "my-security-group",
  "iam": {
    "security-credentials": {
      "my-role": {
        "AccessKeyId": "AKIAEXAMPLE",
        "SecretAccessKey": "secret1234",
        "Token": "token1234",
        "Expiration": "2025-02-16T12:00:00Z"
      }
    }
  }
}
```

---

### 2. Fetch a Specific Metadata Key (Correct Key Case)  
To fetch the value of a specific key, use the `-key` option followed by the valid key name.

```bash
./script_name.sh -key "key"
```

#### Example:
```bash
./script_name.sh -key "instance-id"
```

#### Example Output:
```json
{
  "key": "i-0123456789abcdef0"
}
```

---

### 3. Fetch a Nested Metadata Sub-Key (Correct Key Case)  
If the metadata key has nested paths, specify the full path (e.g., `key/sub-key`) to fetch the corresponding value.

```bash
./script_name.sh -key "key/sub-key"
```

#### Example:
```bash
./script_name.sh -key "iam/security-credentials/my-role"
```

#### Example Output:
```json
{
  "AccessKeyId": "AKIAEXAMPLE",
  "SecretAccessKey": "secret1234",
  "Token": "token1234",
  "Expiration": "2025-02-16T12:00:00Z"
}
```

---

### 4. Handle Incorrect Metadata Key  
If you specify an invalid or non-existent key, the script will return a JSON-formatted error message.

```bash
./script_name.sh -key "key"
```

#### Example:
```bash
./script_name.sh -key "nonexistent-key"
```

#### Example Output:
```json
{
  "error": "Key 'nonexistent-key' not found"
}
```

---

### 5. Handle Invalid usage  
If the script is used incorrectly (e.g., missing arguments or invalid flags), it displays helpful usage instructions.

```bash
./script_name.sh -key "key"
```

#### Example:
```bash
./script_name.sh -key "nonexistent-key"
```

#### Example Output:
```json
{
  "error": "Key 'nonexistent-key' not found"
}
```

--- Metadata Key  
If you specify an invalid or non-existent key, the script will return a JSON-formatted error message.

#### Example:
```bash
./metadata_query.sh some-wrong-arg
```

#### Example Output:
```bash
Usage:
1. ./metadata_query.sh                 # Fetch all metadata keys
2. ./metadata_query.sh -key <key>      # Fetch specific metadata by key
3. ./metadata_query.sh -key <key/sub-key>  # Fetch nested metadata by key path

Example:
./metadata_query.sh -key instance-id
./metadata_query.sh -key iam/security-credentials/my-role

Error: Invalid usage. Please refer to the above examples.
```