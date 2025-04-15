USE libreria;

-- Creación de las tablas
CREATE TABLE editoras (
editora_id INT PRIMARY KEY AUTO_INCREMENT,
editora VARCHAR(155)

);

CREATE TABLE libros (
    libro_id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255),
    autor_id INT, -- referencia al autor
	editora_id INT, -- referencia a la editora
    año_publicacion INT,
    FOREIGN KEY (autor_id) REFERENCES autores(autor_id),
    FOREIGN KEY (editora_id) REFERENCES editoras(editora_id)
);-- 

CREATE TABLE autores (
    autor_id INT PRIMARY KEY AUTO_INCREMENT UNIQUE,
    autor VARCHAR(100)
);


SELECT *
FROM libros;

SELECT *
FROM libros
WHERE autor_id = 5;

SELECT *
FROM autores;

-- Consultar número de libros publicados por autor
SELECT autor, (SELECT COUNT(*) 
				FROM libros 
                WHERE libros.autor_id = autores.autor_id) AS Total_Libros
FROM autores;

-- Consultar editoras que tengan más de un libro publicado 
SELECT editora, total_libros
FROM (
    SELECT 
        e.editora,
        COUNT(*) AS total_libros
    FROM libros l
    JOIN editoras e ON l.editora_id = e.editora_id
    GROUP BY e.editora
) AS resumen
WHERE total_libros > 1;

-- Consultar el total de libros publicados del autor.
SELECT *
FROM (
    SELECT 
        l.titulo,
        a.autor,
        COUNT(*) OVER (PARTITION BY l.autor_id) AS libros_por_autor
    FROM libros l
    JOIN autores a ON l.autor_id = a.autor_id
) AS libros_filtrados
WHERE libros_por_autor > 0;

-- Consultar por nombre del autor los libros que tiene publicados.
SELECT *
FROM libros
WHERE autor_id = (
    SELECT autor_id
    FROM autores
    WHERE autor = 'J.K. Rowling'
);

-- Consultar autores que han escrito al menos un libro publicado por Ace Books
SELECT *
FROM autores
WHERE autor_id IN (
    SELECT autor_id
    FROM libros
    WHERE editora_id = (
        SELECT editora_id
        FROM editoras
        WHERE editora = 'Ace Books'
    )
);


-- Consultar editora y titulo del libro
SELECT e.editora, l.titulo
FROM editoras e
LEFT JOIN libros l ON e.editora_id = l.editora_id;


-- Consultar lanzamientos por año.
SELECT 
    a.autor,
    l1.año_publicacion,
    COUNT(*) AS total_libros
FROM libros l1
JOIN autores a ON l1.autor_id = a.autor_id
GROUP BY l1.autor_id, l1.año_publicacion
HAVING COUNT(*) = (
    SELECT MAX(libros_por_anio)
    FROM (
        SELECT COUNT(*) AS libros_por_anio
        FROM libros l2
        WHERE l2.autor_id = l1.autor_id
        GROUP BY l2.año_publicacion
    ) AS sub
);


-- Consultar tabla con libros, autor, editora y año de publicación
SELECT 
    l.titulo,
    a.autor,
    e.editora,
    l.año_publicacion
FROM libros l
JOIN autores a ON l.autor_id = a.autor_id
JOIN editoras e ON l.editora_id = e.editora_id;
