const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'ecommerce_db',
  password: 'eason0725',
  port: 5432,
});

app.get('/', (req, res) => {
  // 此處處理根路徑的請求
});

app.get('/get_users_data', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server Error');
  }
});

app.get('/get_products_data', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server Error');
  }
});


app.post('/register_users', (req, res) => {
  const { name, email, password, phone, role, registration_date } = req.body;

  pool.query('INSERT INTO users (user_name, email, user_password, phone, role, registration_date) VALUES ($1, $2, $3, $4, $5, $6)',
    [name, email, password, phone, role, registration_date],
    (err, result) => {
      if (err) {
        console.error('Error inserting data:', err);
        res.status(500).json({ error: 'Failed to insert data' });
      } else {
        res.status(201).json({ message: 'Data inserted successfully' });
      }
    });
});

app.get('/get_user/:id', (req, res) => {
  const userId = req.params.id;
  pool.query('SELECT * FROM users WHERE user_id = $1', [userId], (err, result) => {
    if (err) {
      console.error('Error fetching user data:', err);
      res.status(500).json({ error: 'Failed to fetch user data' });
    } else {
      res.status(200).json(result.rows[0]);
    }
  });
});


app.get('/get_product/:id', (req, res) => {
  const productId = req.params.id;
  pool.query('SELECT * FROM products WHERE product_id = $1', [productId], (err, result) => {
    if (err) {
      console.error('Error fetching user data:', err);
      res.status(500).json({ error: 'Failed to fetch user data' });
    } else {
      res.status(200).json(result.rows[0]);
    }
  });
});



app.get('/get_cart/:id', (req, res) => {
  const userId = req.params.id;
  pool.query('SELECT * FROM cart WHERE user_id = $1', [userId], (err, result) => {
    if (err) {
      console.error('Error fetching cart data:', err);
      res.status(500).json({ error: 'Failed to fetch cart data' });
    } else {
      res.status(200).json(result.rows);
    }
  });
});
//----
app.post('/add_to_cart/:id', async (req, res) => {
  const { user_id, product_id, quantity } = req.body;

  const userId = parseInt(user_id);
  const productID = parseInt(product_id);
  const qty = parseInt(quantity);

  if (isNaN(userId) || isNaN(productID) || isNaN(qty)) {
    console.error('Invalid input:', user_id, product_id, quantity);
    res.status(400).json({ error: 'Invalid input' });
    return;
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');


    const insertCartQuery = 'INSERT INTO cart (user_id, product_id, quantity) VALUES ($1, $2, $3)';
    await client.query(insertCartQuery, [userId, productID, qty]);

    //更新
    const updateProductQuery = 'UPDATE products SET stock_quantity = stock_quantity - $1 WHERE product_id = $2';
    await client.query(updateProductQuery, [qty, productID]);

    await client.query('COMMIT');
    res.status(201).json({ message: 'Data inserted successfully and product quantity updated' });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error processing request:', err);
    res.status(500).json({ error: 'Failed to process request' });
  } finally {
    client.release();
  }
});




//----
app.get('/get_product_by_merchantId/:merchantId', async (req, res) => {
  const { merchantId } = req.params;

  pool.query('SELECT * FROM products WHERE merchant_id = $1', [merchantId], (err, result) => {
    if (err) {
      console.error('Error fetching product data:', err);
      res.status(500).json({ error: 'Failed to fetch product data' });
    } else {
      res.status(200).json(result.rows);
    }
  });


});


app.delete('/delete_cart', async (req, res) => {
  const { userId, productId } = req.body;

  try {
    const result = await pool.query('DELETE FROM cart WHERE user_id = $1 AND product_id = $2', [userId, productId]);
    res.send('Cart item deleted successfully');
  } catch (err) {
    console.error(err);
    res.status(500).send('Server Error');
  }
});

app.delete('/clean_cart', async (req, res) => {
  const { userId } = req.body;

  try {
    const result = await pool.query('DELETE FROM cart WHERE user_id = $1', [userId]);
    res.send('Cart deleted successfully');
  } catch (err) {
    console.error(err);
    res.status(500).send('Server Error');
  }
});
//--------------------------
async function insertProduct(merchantId, productName, productDescription, productImage, price, stockQuantity, category, addedDate, status) {
  const queryString = `
    INSERT INTO products (merchant_id, product_name, product_description, product_image, price, stock_quantity, category, added_date, status)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
  `;
  const values = [merchantId, productName, productDescription, productImage, price, stockQuantity, category, addedDate, status];

  try {
    const result = await pool.query(queryString, values);
    console.log('Data inserted successfully');
    return result.rowCount; // 返回插入的行數
  } catch (error) {
    console.error('Failed to insert data:', error);
    throw error;
  }
}

app.post('/add_product/:id', (req, res) => {
    const {merchantId, name,  description,image, price, quantity, category,addedData, status} = req.body;
    const merchant_Id = parseInt(merchantId);
    const intPrice = parseInt(price);
    const qty = parseInt(quantity);
    pool.query('INSERT INTO products (merchant_id , product_name , product_description,product_image,price,stock_quantity,category , added_date , status) VALUES ($1, $2, $3,$4,$5,$6,$7,$8,$9)',
      [merchant_Id, name, description,image,intPrice,qty,category,addedData,status],
      (err, result) => {
        if (err) {
          console.error('Error inserting data:', err);
          res.status(500).json({ error: 'Failed to insert data to SQL' });
        } else {
          res.status(201).json({ message: 'Data inserted successfully' });
        }
      });
});
//----------------

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
