-- Active: 1663598297600@@127.0.0.1@3306@universidad
--Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. 
--El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre FROM persona WHERE tipo = 'alumno' ORDER BY apellido1, apellido2, nombre;
--Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre, apellido1, apellido2 FROM persona WHERE tipo = 'alumno' AND telefono IS NULL;
--Retorna el llistat dels alumnes que van néixer en 1999.
SELECT * FROM persona WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;
--Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.
SELECT * FROM persona WHERE tipo = 'profesor' AND telefono IS NULL AND nif LIKE '%K';
--Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT * FROM asignatura WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;
--Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. 
--El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. 
--El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT p.apellido1, p.apellido2, p.nombre AS 'nombre profesor', d.nombre AS 'nombre departamento' FROM persona p INNER JOIN profesor pro ON pro.id_profesor = p.id INNER JOIN departamento d ON d.id = pro.id_departamento ORDER BY p.apellido1, p.apellido2, p.nombre;
--Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.
SELECT a.nombre, c.anyo_inicio, c.anyo_fin FROM persona p INNER JOIN alumno_se_matricula_asignatura matr ON p.id = matr.id_alumno INNER JOIN asignatura a ON matr.id_asignatura = a.id INNER JOIN curso_escolar c ON c.id = matr.id_curso_escolar WHERE p.nif = '26902806M';
--Retorna un llistat amb el nom de tots els departaments que tenen professors/es 
--que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT DISTINCT d.nombre FROM departamento d INNER JOIN profesor prof ON d.id = prof.id_departamento INNER JOIN asignatura a ON prof.id_profesor = a.id_profesor INNER JOIN grado g ON a.id_grado = g.id WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

--Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT DISTINCT p.* FROM persona p INNER JOIN alumno_se_matricula_asignatura matr ON matr.id_alumno = p.id INNER JOIN curso_escolar c ON c.id = matr.id_curso_escolar WHERE c.anyo_inicio = 2018 AND c.anyo_fin = 2019;


--Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.
--Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. 
--El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. 
--El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. 
--El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
--SELECT * FROM persona WHERE tipo = 'profesor';
SELECT DISTINCT d.nombre AS 'nombre departamento', p.apellido1, p.apellido2, p.nombre AS 'nombre profesor' FROM persona p LEFT JOIN profesor prof ON prof.id_profesor = p.id LEFT JOIN departamento d ON d.id = prof.id_departamento WHERE p.tipo = 'profesor' ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre;
 
--Retorna un llistat amb els professors/es que no estan associats a un departament.
SELECT p.* FROM persona p LEFT JOIN profesor prof ON p.id = prof.id_profesor WHERE tipo = 'profesor' AND prof.id_departamento IS NULL;
--Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT d.nombre AS 'nombre departamento' FROM departamento d LEFT JOIN profesor prof ON prof.id_departamento = d.id WHERE prof.id_departamento IS NULL;
--Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT p.* FROM persona p LEFT JOIN profesor prof ON prof.id_profesor = p.id LEFT JOIN asignatura a ON a.id_profesor = prof.id_profesor WHERE a.id IS NULL AND p.tipo = 'profesor';
--Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT * FROM asignatura WHERE id_profesor IS NULL;
--Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT DISTINCT d.* FROM alumno_se_matricula_asignatura matr LEFT JOIN asignatura a ON matr.id_asignatura = a.id LEFT JOIN profesor prof ON a.id_profesor = prof.id_profesor RIGHT JOIN departamento d ON prof.id_departamento = d.id WHERE matr.id_curso_escolar IS NULL;


--Consultes resum:
--Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(*) FROM persona WHERE tipo = 'alumno';
--Calcula quants alumnes van néixer en 1999.
SELECT COUNT(*) FROM persona WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;
--Calcula quants professors/es hi ha en cada departament. 
--El resultat només ha de mostrar dues columnes, una amb el nom del departament i 
--una altra amb el nombre de professors/es que hi ha en aquest departament. 
--El resultat només ha d'incloure els departaments que tenen professors/es associats i 
--haurà d'estar ordenat de major a menor pel nombre de professors/es.
SELECT d.nombre, COUNT(*) AS 'numero de profesores' FROM departamento d INNER JOIN profesor prof ON d.id = prof.id_departamento GROUP BY d.nombre ORDER BY COUNT(*) DESC;
--Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. 
--Tingui en compte que poden existir departaments que no tenen professors/es associats. 
--Aquests departaments també han d'aparèixer en el llistat.
SELECT d.nombre, COUNT(prof.id_profesor) AS 'numero de profesores' FROM departamento d LEFT JOIN profesor prof ON d.id = prof.id_departamento GROUP BY d.nombre;
--Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. 
--Tingues en compte que poden existir graus que no tenen assignatures associades. 
--Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT g.nombre AS 'grado', COUNT(g.id) AS 'numero asignaturas' FROM grado g LEFT JOIN asignatura a ON g.id = a.id_grado GROUP BY g.nombre ORDER BY COUNT(*) DESC;
--Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, 
--dels graus que tinguin més de 40 assignatures associades.
SELECT g.nombre AS 'grado', COUNT(*) AS 'numero asignaturas' FROM grado g INNER JOIN asignatura a ON a.id_grado = g.id GROUP BY g.id HAVING COUNT(*) > 40;

--Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. 
--El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
SELECT g.nombre, a.tipo, SUM(a.creditos) AS creditos FROM grado g INNER JOIN asignatura a ON a.id_grado = g.id GROUP BY g.nombre, a.tipo;
--Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. 
--El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
SELECT c.anyo_inicio, COUNT(matr.id_alumno) AS alumnos FROM curso_escolar c INNER JOIN alumno_se_matricula_asignatura matr ON c.id = matr.id_curso_escolar GROUP BY c.id;
--Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. 
--El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. 
--El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. 
--El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS 'numero asignaturas' FROM persona p LEFT JOIN asignatura a ON p.id = a.id_profesor GROUP BY p.id ORDER BY COUNT(a.id);
--Retorna totes les dades de l'alumne/a més jove.
SELECT * FROM persona WHERE tipo = 'alumno' ORDER BY fecha_nacimiento DESC LIMIT 1;
--Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.
SELECT p.* FROM profesor prof LEFT JOIN asignatura a ON a.id_profesor = prof.id_profesor INNER JOIN persona p ON p.id = prof.id_profesor WHERE a.id_profesor IS NULL;