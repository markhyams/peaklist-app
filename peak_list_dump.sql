--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 9.6.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ascents; Type: TABLE; Schema: public; Owner: ec2-user
--

CREATE TABLE public.ascents (
    id integer NOT NULL,
    user_id integer NOT NULL,
    peak_id integer NOT NULL,
    date date NOT NULL,
    note text
);


ALTER TABLE public.ascents OWNER TO "ec2-user";

--
-- Name: ascents_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE public.ascents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ascents_id_seq OWNER TO "ec2-user";

--
-- Name: ascents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE public.ascents_id_seq OWNED BY public.ascents.id;


--
-- Name: peaks; Type: TABLE; Schema: public; Owner: ec2-user
--

CREATE TABLE public.peaks (
    id integer NOT NULL,
    name text NOT NULL,
    elevation integer NOT NULL,
    prominence integer NOT NULL,
    isolation numeric(6,2),
    parent text,
    county text NOT NULL,
    quad text NOT NULL,
    state character(2) NOT NULL
);


ALTER TABLE public.peaks OWNER TO "ec2-user";

--
-- Name: peaks_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE public.peaks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.peaks_id_seq OWNER TO "ec2-user";

--
-- Name: peaks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE public.peaks_id_seq OWNED BY public.peaks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: ec2-user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(100) NOT NULL
);


ALTER TABLE public.users OWNER TO "ec2-user";

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO "ec2-user";

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: ascents id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.ascents ALTER COLUMN id SET DEFAULT nextval('public.ascents_id_seq'::regclass);


--
-- Name: peaks id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.peaks ALTER COLUMN id SET DEFAULT nextval('public.peaks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ascents; Type: TABLE DATA; Schema: public; Owner: ec2-user
--

INSERT INTO public.ascents VALUES (8, 1, 28, '2015-07-23', 'With Mark and Felicia');
INSERT INTO public.ascents VALUES (10, 3, 31, '2001-07-09', '');
INSERT INTO public.ascents VALUES (11, 3, 31, '2019-06-09', 'Great days in the wilderness.');
INSERT INTO public.ascents VALUES (14, 5, 15, '1993-07-26', 'First 14er ever!');
INSERT INTO public.ascents VALUES (15, 5, 1, '1994-07-16', 'Second fourteener of the summer, and third overall. Climbed with two percussionists from the Aspen Music Festival.  Unfortunately I don''t remember their names. :(');
INSERT INTO public.ascents VALUES (16, 5, 5, '1994-07-24', '');
INSERT INTO public.ascents VALUES (17, 5, 52, '1994-07-30', '');
INSERT INTO public.ascents VALUES (18, 5, 47, '1994-08-01', '');
INSERT INTO public.ascents VALUES (19, 5, 24, '1994-08-08', 'Met a guy on top who was trying to sleep on top of all the 14ers.');
INSERT INTO public.ascents VALUES (20, 5, 26, '1994-08-11', '');
INSERT INTO public.ascents VALUES (21, 5, 19, '1994-08-11', '');
INSERT INTO public.ascents VALUES (22, 5, 36, '1994-08-11', '');
INSERT INTO public.ascents VALUES (23, 5, 45, '1994-08-22', '');
INSERT INTO public.ascents VALUES (24, 5, 38, '1994-08-27', '');
INSERT INTO public.ascents VALUES (25, 5, 14, '1994-08-27', '');
INSERT INTO public.ascents VALUES (26, 4, 15, '2019-07-09', 'so scary');
INSERT INTO public.ascents VALUES (28, 5, 15, '1993-09-11', '');
INSERT INTO public.ascents VALUES (29, 5, 51, '1994-09-03', '');
INSERT INTO public.ascents VALUES (30, 5, 8, '1994-09-10', '');
INSERT INTO public.ascents VALUES (31, 5, 22, '1994-09-10', '');
INSERT INTO public.ascents VALUES (32, 5, 28, '1994-09-10', '');
INSERT INTO public.ascents VALUES (33, 5, 25, '1995-08-13', '');
INSERT INTO public.ascents VALUES (34, 5, 27, '1995-08-15', '');
INSERT INTO public.ascents VALUES (35, 5, 49, '1995-08-16', '');
INSERT INTO public.ascents VALUES (36, 5, 7, '1995-09-03', 'Climbed on Labor Day weekend, with Dan and Tadd. Squeezed into the tent on a windy night.');
INSERT INTO public.ascents VALUES (37, 5, 21, '1995-09-24', '');
INSERT INTO public.ascents VALUES (38, 5, 18, '1995-11-25', '');
INSERT INTO public.ascents VALUES (39, 5, 10, '1996-03-30', '');
INSERT INTO public.ascents VALUES (40, 5, 38, '1996-04-23', '');
INSERT INTO public.ascents VALUES (41, 5, 17, '1996-06-19', '');
INSERT INTO public.ascents VALUES (42, 5, 3, '1996-06-30', '');
INSERT INTO public.ascents VALUES (43, 5, 29, '1996-07-06', '');
INSERT INTO public.ascents VALUES (44, 5, 30, '1996-07-14', '');
INSERT INTO public.ascents VALUES (46, 5, 44, '1996-07-30', '');
INSERT INTO public.ascents VALUES (47, 5, 43, '1996-08-01', '');
INSERT INTO public.ascents VALUES (48, 5, 48, '1996-08-14', '');
INSERT INTO public.ascents VALUES (49, 5, 2, '1996-09-07', '');
INSERT INTO public.ascents VALUES (50, 5, 9, '1994-09-17', '');
INSERT INTO public.ascents VALUES (51, 5, 11, '1994-09-17', '');
INSERT INTO public.ascents VALUES (52, 5, 13, '1994-10-02', '');
INSERT INTO public.ascents VALUES (53, 5, 13, '1994-11-07', '');
INSERT INTO public.ascents VALUES (54, 5, 13, '1997-05-08', '');
INSERT INTO public.ascents VALUES (55, 5, 35, '1997-06-03', '');
INSERT INTO public.ascents VALUES (56, 5, 6, '1997-06-08', '');
INSERT INTO public.ascents VALUES (57, 5, 41, '1997-06-14', '');
INSERT INTO public.ascents VALUES (58, 5, 16, '1997-07-07', '');
INSERT INTO public.ascents VALUES (59, 5, 50, '1998-07-01', '');
INSERT INTO public.ascents VALUES (60, 5, 46, '1998-08-15', '');
INSERT INTO public.ascents VALUES (61, 5, 53, '1998-08-15', '');
INSERT INTO public.ascents VALUES (62, 5, 40, '1998-08-16', '');
INSERT INTO public.ascents VALUES (63, 5, 15, '1998-08-30', '');
INSERT INTO public.ascents VALUES (64, 5, 42, '1999-06-10', '');
INSERT INTO public.ascents VALUES (65, 5, 37, '1999-06-17', '');
INSERT INTO public.ascents VALUES (66, 5, 9, '1999-07-19', '');
INSERT INTO public.ascents VALUES (67, 5, 11, '1999-07-19', '');
INSERT INTO public.ascents VALUES (68, 5, 31, '1999-07-28', '');
INSERT INTO public.ascents VALUES (69, 5, 33, '1999-08-03', '');
INSERT INTO public.ascents VALUES (70, 5, 32, '1999-08-04', '');
INSERT INTO public.ascents VALUES (71, 5, 39, '1999-08-04', '');
INSERT INTO public.ascents VALUES (72, 5, 23, '1999-08-20', '');
INSERT INTO public.ascents VALUES (73, 5, 20, '1999-08-21', '');
INSERT INTO public.ascents VALUES (74, 5, 15, '1999-08-26', '');
INSERT INTO public.ascents VALUES (75, 5, 20, '2000-08-08', '');
INSERT INTO public.ascents VALUES (76, 5, 15, '2000-08-16', '');
INSERT INTO public.ascents VALUES (77, 5, 15, '2000-08-30', '');
INSERT INTO public.ascents VALUES (78, 5, 22, '2001-03-04', '');
INSERT INTO public.ascents VALUES (79, 5, 38, '2001-06-28', '');
INSERT INTO public.ascents VALUES (80, 5, 10, '2003-06-09', '');
INSERT INTO public.ascents VALUES (81, 5, 30, '2003-06-13', '');
INSERT INTO public.ascents VALUES (82, 5, 45, '2003-06-17', '');
INSERT INTO public.ascents VALUES (83, 5, 52, '2003-07-03', '');
INSERT INTO public.ascents VALUES (84, 5, 15, '2003-07-18', '');
INSERT INTO public.ascents VALUES (87, 5, 27, '2005-07-21', '');
INSERT INTO public.ascents VALUES (88, 5, 51, '2006-07-24', '');
INSERT INTO public.ascents VALUES (89, 5, 34, '2007-06-11', '');
INSERT INTO public.ascents VALUES (90, 5, 27, '2012-07-24', '');
INSERT INTO public.ascents VALUES (91, 5, 38, '2013-07-16', '');
INSERT INTO public.ascents VALUES (92, 5, 8, '2015-07-23', '');
INSERT INTO public.ascents VALUES (93, 5, 22, '2015-07-23', '');
INSERT INTO public.ascents VALUES (94, 5, 28, '2015-07-23', '');
INSERT INTO public.ascents VALUES (95, 5, 15, '2015-08-06', '');
INSERT INTO public.ascents VALUES (96, 5, 20, '2015-08-15', '');
INSERT INTO public.ascents VALUES (97, 5, 54, '1994-07-27', '');
INSERT INTO public.ascents VALUES (98, 5, 55, '1999-08-17', '');
INSERT INTO public.ascents VALUES (99, 1, 8, '2015-07-23', '');
INSERT INTO public.ascents VALUES (100, 1, 22, '2015-07-23', '');
INSERT INTO public.ascents VALUES (101, 1, 15, '2015-08-06', '');
INSERT INTO public.ascents VALUES (102, 1, 38, '2013-07-16', '');
INSERT INTO public.ascents VALUES (103, 1, 27, '2012-07-24', '');
INSERT INTO public.ascents VALUES (105, 2, 27, '2012-07-24', 'Climbed it twice that day!');
INSERT INTO public.ascents VALUES (106, 3, 40, '2014-06-12', 'Climbed this one many times! I wish I wrote down the dates. Beautiful!!');
INSERT INTO public.ascents VALUES (104, 3, 1, '2019-07-10', 'test again');
INSERT INTO public.ascents VALUES (108, 3, 10, '2019-08-10', '');
INSERT INTO public.ascents VALUES (85, 5, 1, '2004-06-07', 'On a road trip that ended in Durango');
INSERT INTO public.ascents VALUES (86, 5, 3, '2004-07-07', 'With Josh M and his dogs, Jake and Biff');
INSERT INTO public.ascents VALUES (13, 5, 12, '1994-07-11', 'First real fourteener! Left Eric S on the northeast ridge while I went the summit solo.');
INSERT INTO public.ascents VALUES (45, 5, 4, '1996-07-30', 'Traversed from Little Bear. Tough route!');
INSERT INTO public.ascents VALUES (109, 2, 5, '2019-08-10', 'I climbed this in five minutes!');


--
-- Name: ascents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ec2-user
--

SELECT pg_catalog.setval('public.ascents_id_seq', 109, true);


--
-- Data for Name: peaks; Type: TABLE DATA; Schema: public; Owner: ec2-user
--

INSERT INTO public.peaks VALUES (1, 'Elbert, Mount', 14433, 9093, 669.95, 'Whitney, Mount', 'Lake', 'Mount Elbert', 'CO');
INSERT INTO public.peaks VALUES (2, 'Massive, Mount', 14421, 1961, 5.08, 'Elbert, Mount', 'Lake', 'Mount Massive', 'CO');
INSERT INTO public.peaks VALUES (3, 'Harvard, Mount', 14420, 2360, 14.96, 'Elbert, Mount', 'Chaffee', 'Mount Harvard', 'CO');
INSERT INTO public.peaks VALUES (4, 'Blanca Peak', 14345, 5326, 103.61, 'Harvard, Mount', 'Alamosa & Costilla', 'Blanca Peak', 'CO');
INSERT INTO public.peaks VALUES (5, 'La Plata Peak', 14336, 1836, 6.29, 'Elbert, Mount', 'Chaffee', 'Mount Elbert', 'CO');
INSERT INTO public.peaks VALUES (6, 'Uncompahgre Peak', 14309, 4242, 85.16, 'La Plata Peak', 'Hinsdale', 'Uncompahgre Peak', 'CO');
INSERT INTO public.peaks VALUES (7, 'Crestone Peak', 14294, 4554, 27.47, 'Blanca Peak', 'Saguache', 'Crestone Peak', 'CO');
INSERT INTO public.peaks VALUES (8, 'Lincoln, Mount', 14286, 3862, 22.57, 'Massive, Mount', 'Park', 'Alma', 'CO');
INSERT INTO public.peaks VALUES (9, 'Grays Peak', 14270, 2770, 25.05, 'Lincoln, Mount', 'Clear Creek & Summit', 'Grays Peak', 'CO');
INSERT INTO public.peaks VALUES (10, 'Antero, Mount', 14269, 2503, 17.77, 'Harvard, Mount', 'Chaffee', 'Mount Antero', 'CO');
INSERT INTO public.peaks VALUES (11, 'Torreys Peak', 14267, 560, 0.65, 'Grays Peak', 'Clear Creek & Summit', 'Grays Peak', 'CO');
INSERT INTO public.peaks VALUES (12, 'Castle Peak', 14265, 2365, 20.91, 'La Plata Peak', 'Gunnison & Pitkin', 'Hayden Peak', 'CO');
INSERT INTO public.peaks VALUES (13, 'Quandary Peak', 14265, 1125, 3.18, 'Lincoln, Mount', 'Summit', 'Breckenridge', 'CO');
INSERT INTO public.peaks VALUES (14, 'Evans, Mount', 14264, 2764, 9.79, 'Grays Peak', 'Clear Creek', 'Mount Evans', 'CO');
INSERT INTO public.peaks VALUES (15, 'Longs Peak', 14255, 2940, 43.74, 'Torreys Peak', 'Boulder', 'Longs Peak', 'CO');
INSERT INTO public.peaks VALUES (16, 'Wilson, Mount', 14246, 4024, 33.05, 'Uncompahgre Peak', 'Dolores', 'Mount Wilson', 'CO');
INSERT INTO public.peaks VALUES (17, 'Shavano, Mount', 14229, 1619, 3.82, 'Antero, Mount', 'Chaffee', 'Maysville', 'CO');
INSERT INTO public.peaks VALUES (18, 'Princeton, Mount', 14197, 2177, 5.21, 'Antero, Mount', 'Chaffee', 'Mount Antero', 'CO');
INSERT INTO public.peaks VALUES (19, 'Belford, Mount', 14197, 1337, 3.32, 'Harvard, Mount', 'Chaffee', 'Mount Harvard', 'CO');
INSERT INTO public.peaks VALUES (20, 'Crestone Needle', 14197, 457, 0.49, 'Crestone Peak', 'Custer & Saguache', 'Crestone Peak', 'CO');
INSERT INTO public.peaks VALUES (21, 'Yale, Mount', 14196, 1896, 5.56, 'Harvard, Mount', 'Chaffee', 'Mount Yale', 'CO');
INSERT INTO public.peaks VALUES (22, 'Bross, Mount', 14172, 312, 1.13, 'Lincoln, Mount', 'Park', 'Alma', 'CO');
INSERT INTO public.peaks VALUES (23, 'Kit Carson Mountain', 14165, 1025, 1.30, 'Crestone Peak', 'Saguache', 'Crestone Peak', 'CO');
INSERT INTO public.peaks VALUES (24, 'Maroon Peak', 14156, 2336, 8.06, 'Castle Peak', 'Gunnison & Pitkin', 'Maroon Bells', 'CO');
INSERT INTO public.peaks VALUES (25, 'Tabeguache Peak', 14155, 455, 0.75, 'Shavano, Mount', 'Chaffee', 'Saint Elmo', 'CO');
INSERT INTO public.peaks VALUES (26, 'Oxford, Mount', 14153, 653, 1.23, 'Belford, Mount', 'Chaffee', 'Mount Harvard', 'CO');
INSERT INTO public.peaks VALUES (27, 'Sneffels, Mount', 14150, 3050, 15.74, 'Wilson, Mount', 'Ouray', 'Mount Sneffels', 'CO');
INSERT INTO public.peaks VALUES (28, 'Democrat, Mount', 14148, 768, 1.73, 'Lincoln, Mount', 'Lake & Park', 'Climax', 'CO');
INSERT INTO public.peaks VALUES (29, 'Capitol Peak', 14130, 1750, 7.46, 'Maroon Peak', 'Pitkin', 'Capitol Peak', 'CO');
INSERT INTO public.peaks VALUES (30, 'Pikes Peak', 14110, 5530, 60.88, 'Evans, Mount', 'El Paso', 'Pikes Peak', 'CO');
INSERT INTO public.peaks VALUES (31, 'Snowmass Mountain', 14092, 1152, 2.34, 'Capitol Peak', 'Gunnison & Pitkin', 'Snowmass Mountain', 'CO');
INSERT INTO public.peaks VALUES (32, 'Windom Peak', 14087, 2187, 26.55, 'Wilson, Mount', 'La Plata', 'Columbine Pass', 'CO');
INSERT INTO public.peaks VALUES (33, 'Eolus, Mount', 14083, 1023, 1.68, 'Windom Peak', 'La Plata', 'Columbine Pass', 'CO');
INSERT INTO public.peaks VALUES (34, 'Challenger Point', 14081, 301, 0.23, 'Kit Carson Mountain', 'Saguache', 'Crestone Peak', 'CO');
INSERT INTO public.peaks VALUES (35, 'Columbia, Mount', 14073, 893, 1.89, 'Harvard, Mount', 'Chaffee', 'Mount Harvard', 'CO');
INSERT INTO public.peaks VALUES (36, 'Missouri Mountain', 14067, 847, 1.30, 'Belford, Mount', 'Chaffee', 'Winfield', 'CO');
INSERT INTO public.peaks VALUES (37, 'Humboldt Peak', 14064, 1204, 1.42, 'Crestone Needle', 'Custer', 'Crestone Peak', 'CO');
INSERT INTO public.peaks VALUES (38, 'Bierstadt, Mount', 14060, 720, 1.41, 'Evans, Mount', 'Clear Creek', 'Mount Evans', 'CO');
INSERT INTO public.peaks VALUES (39, 'Sunlight Peak', 14059, 399, 0.47, 'Windom Peak', 'La Plata', 'Storm King Peak', 'CO');
INSERT INTO public.peaks VALUES (40, 'Handies Peak', 14048, 1908, 11.22, 'Uncompahgre Peak', 'Hinsdale', 'Handies Peak', 'CO');
INSERT INTO public.peaks VALUES (41, 'Culebra Peak', 14047, 4827, 35.55, 'Blanca Peak', 'Costilla', 'Culebra Peak', 'CO');
INSERT INTO public.peaks VALUES (42, 'Lindsey, Mount', 14042, 1542, 2.28, 'Blanca Peak', 'Costilla', 'Blanca Peak', 'CO');
INSERT INTO public.peaks VALUES (43, 'Ellingwood Point', 14042, 342, 0.51, 'Blanca Peak', 'Alamosa & Huerfano', 'Blanca Peak', 'CO');
INSERT INTO public.peaks VALUES (44, 'Little Bear Peak', 14037, 377, 0.98, 'Blanca Peak', 'Alamosa & Costilla', 'Blanca Peak', 'CO');
INSERT INTO public.peaks VALUES (45, 'Sherman, Mount', 14036, 896, 8.10, 'Democrat, Mount', 'Lake & Park', 'Mount Sherman', 'CO');
INSERT INTO public.peaks VALUES (46, 'Redcloud Peak', 14034, 1436, 4.91, 'Handies Peak', 'Hinsdale', 'Redcloud Peak', 'CO');
INSERT INTO public.peaks VALUES (47, 'Pyramid Peak', 14018, 1638, 2.08, 'Maroon Peak', 'Pitkin', 'Maroon Bells', 'CO');
INSERT INTO public.peaks VALUES (48, 'Wilson Peak', 14017, 877, 1.51, 'Wilson, Mount', 'San Miguel', 'Mount Wilson', 'CO');
INSERT INTO public.peaks VALUES (49, 'Wetterhorn Peak', 14015, 1635, 2.76, 'Uncompahgre Peak', 'Hinsdale & Ouray', 'Wetterhorn Peak', 'CO');
INSERT INTO public.peaks VALUES (50, 'San Luis Peak', 14014, 3114, 26.93, 'Redcloud Peak', 'Saguache', 'San Luis Peak', 'CO');
INSERT INTO public.peaks VALUES (51, 'Holy Cross, Mount of the', 14005, 2111, 19.33, 'Massive, Mount', 'Eagle', 'Mount of the Holy Cross', 'CO');
INSERT INTO public.peaks VALUES (52, 'Huron Peak', 14003, 1423, 3.20, 'Missouri Mountain', 'Chaffee', 'Winfield', 'CO');
INSERT INTO public.peaks VALUES (53, 'Sunshine Peak', 14001, 501, 1.27, 'Redcloud Peak', 'Hinsdale', 'Redcloud Peak', 'CO');
INSERT INTO public.peaks VALUES (54, 'North Maroon Peak', 14014, 234, 0.37, 'Maroon Peak', 'Pitkin', 'Maroon Bells', 'CO');
INSERT INTO public.peaks VALUES (55, 'El Diente Peak', 14159, 259, 0.75, 'Wilson, Mount', 'Dolores', 'Dolores Peak', 'CO');


--
-- Name: peaks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ec2-user
--

SELECT pg_catalog.setval('public.peaks_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: ec2-user
--

INSERT INTO public.users VALUES (5, 'mark', '$2a$12$5rBkT74N93c8qYChIxwPpe6FenQhqQHk7B5i/ZOJaK4PWwnzE277.');
INSERT INTO public.users VALUES (1, 'julia', '$2a$12$9bEzqZ0sMk7PIk8MULCrDOBalhXeAHhmRND1xAAKRnzJgw7RuOG.u');
INSERT INTO public.users VALUES (2, 'steve', '$2a$12$kXIvtEaGSpfmXVC2ho8i6eQnRUB2cu6.WvSMfflgQejxW5SM0itGy');
INSERT INTO public.users VALUES (3, 'andrew', '$2a$12$pBVA7q2pvNNd7SxXKIpeAu2eki98DPqiUjLn7ZcKjQp6KWVzmRhsS');
INSERT INTO public.users VALUES (4, 'erdwomann', '$2a$12$wfdM4vOgpwJ5tJF16V2zruMwBA12Mhl4vlks//e.OJtK4H2DL3Zl6');


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ec2-user
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- Name: ascents ascents_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.ascents
    ADD CONSTRAINT ascents_pkey PRIMARY KEY (id);


--
-- Name: peaks peaks_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.peaks
    ADD CONSTRAINT peaks_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: ascents ascents_peak_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.ascents
    ADD CONSTRAINT ascents_peak_id_fkey FOREIGN KEY (peak_id) REFERENCES public.peaks(id) ON DELETE CASCADE;


--
-- Name: ascents ascents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY public.ascents
    ADD CONSTRAINT ascents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

