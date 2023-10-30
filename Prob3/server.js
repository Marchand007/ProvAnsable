const express = require('express');
const pool = require('./db');
const port = 1337;

const app = express();
app.use(express.json())
app.get('/', async (req, res) =>
{
    try
    {
        const data = await pool.query(`SELECT * FROM schools`);
        res.status(200).send({
            children: data.rows
        });
    }
    catch (err)
    {
        console.error(err)
        res.sendStatus(500)
    }
});

app.get('/setup', async (req, res) =>
{
    try
    {
        await pool.query(`CREATE TABLE schools(id SERIAL PRIMARY KEY, name VARCHAR(100), address VARCHAR(255))`);
        res.status(200).send({
            message: "SUCCESS - Table Created"
        })
    }
    catch (err)
    {

        console.error(err)
        res.sendStatus(500)
    }
});

app.post('/', async (req, res) =>
{
    const { name, location } = req.body;
    try
    {
        await pool.query(`INSERT INTO schools (name, address) VALUES ($1, $2)`,[name,location]);
        res.status(200).send({
            message: `SUCCESS - Children created : ${name} (${location})`
        })
    }
    catch (err)
    {
        console.error(err)
        res.sendStatus(500)
    }
});





app.listen(port, () => console.log(`Server started on port : ${port}`));