﻿-- III. Ngôn ngữ truy vấn dữ liệu có cấu trúc:
-- 19. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(*) AS SOHOADON
FROM HOADON
WHERE HOADON.MAKH IS NULL;

/* Cách khác 
SELECT COUNT(*) AS SOHOADON
FROM HOADON
WHERE HOADON.MAKH NOT IN(
	SELECT KHACHHANG.MAKH FROM KHACHHANG
	WHERE KHACHHANG.MAKH = HOADON.MAKH); */

-- 20. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
/* CÁCH KHÁC 
SELECT DISTINCT CTHD.MASP
FROM CTHD
JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
WHERE YEAR(HOADON.NGHD) = 2006; */

SELECT COUNT(DISTINCT MASP) AS SOSANPHAM
FROM CTHD CT INNER JOIN HOADON HD
ON CT.SOHD = HD.SOHD
WHERE YEAR(NGHD) = '2006';

-- 21. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
SELECT MIN( HOADON.TRIGIA) AS GIAMIN, MAX(HOADON.TRIGIA) AS GIAMAX
FROM HOADON

-- 22. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(HOADON.TRIGIA) AS TRIGIATB
FROM HOADON
WHERE YEAR(HOADON.NGHD) = 2006;

-- 23. Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(HOADON.TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(HOADON.NGHD) = 2006;

-- 24. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT TOP 1 HOADON.TRIGIA
FROM HOADON
ORDER BY HOADON.TRIGIA DESC;

-- 25. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT TOP 1 KHACHHANG.HOTEN
FROM KHACHHANG
INNER JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
WHERE YEAR(HOADON.NGHD) = 2006
ORDER BY HOADON.TRIGIA DESC;

-- 26. In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.
SELECT TOP 3 KHACHHANG.MAKH, KHACHHANG.HOTEN
FROM KHACHHANG
JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
ORDER BY HOADON.TRIGIA DESC;

-- 27. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT SANPHAM.MASP, SANPHAM.TENSP
FROM SANPHAM 
WHERE SANPHAM.GIA IN(
	SELECT TOP 3 SANPHAM.GIA
	FROM SANPHAM
	ORDER BY SANPHAM.GIA DESC);

-- 28. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm)
SELECT SANPHAM.MASP, SANPHAM.TENSP
FROM SANPHAM
WHERE SANPHAM.GIA IN(SELECT TOP 3 SANPHAM.GIA FROM SANPHAM) AND SANPHAM.NUOCSX = 'Thai Lan'

--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất 
-- (của sản phẩm do “Trung Quoc” sản xuất)
SELECT SANPHAM.MASP, SANPHAM.TENSP
FROM SANPHAM
WHERE SANPHAM.GIA IN( SELECT TOP 3 SANPHAM.GIA
	FROM SANPHAM
	WHERE SANPHAM.NUOCSX = 'Trung Quoc'
	ORDER BY SANPHAM.GIA)
AND SANPHAM.NUOCSX = 'Trung Quoc';

-- 30. * In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
SELECT MASP, TENSP FROM SANPHAM
WHERE NUOCSX = 'Thai Lan' AND GIA IN(
	SELECT DISTINCT TOP 3 GIA FROM SANPHAM
	ORDER BY GIA DESC
);

-- 31. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(SANPHAM.MASP) AS SOSANPHAM
FROM SANPHAM
WHERE SANPHAM.NUOCSX = 'Trung Quoc'

-- 32. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT DISTINCT SANPHAM.NUOCSX, COUNT(SANPHAM.MASP) AS TONGSOSP
FROM SANPHAM
GROUP BY SANPHAM.NUOCSX;

-- 33. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm
SELECT SANPHAM.NUOCSX, MAX(SANPHAM.GIA) AS GIABANCAONHAT, MIN(SANPHAM.GIA) AS GIABANTHAPNHAT, AVG(SANPHAM.GIA) AS GIATB
FROM SANPHAM
GROUP BY SANPHAM.NUOCSX;

-- 34. Tính doanh thu bán hàng mỗi ngày.
SELECT HOADON.NGHD, SUM(HOADON.TRIGIA) AS DOANHTHU
FROM HOADON
GROUP BY HOADON.NGHD;

-- 35. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT COUNT(CTHD.MASP) AS SLSP
FROM CTHD
JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
WHERE YEAR(HOADON.NGHD) = 2006;

-- 36. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(HOADON.NGHD) AS THANG, SUM(HOADON.TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(HOADON.NGHD) = 2006
GROUP BY MONTH(HOADON.NGHD);

-- 37. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT HOADON.SOHD, COUNT(CTHD.MASP) AS SOSANPHAM
FROM HOADON
JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
GROUP BY HOADON.SOHD
HAVING COUNT(CTHD.MASP) >= 4;

-- 38. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT SOHD FROM CTHD CT INNER JOIN SANPHAM SP
ON CT.MASP = SP.MASP
WHERE NUOCSX = 'Viet Nam'
GROUP BY SOHD 
HAVING COUNT(DISTINCT CT.MASP) = 3;

-- 39. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT TOP 1 KHACHHANG.MAKH, KHACHHANG.HOTEN
FROM KHACHHANG
JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
GROUP BY KHACHHANG.MAKH, KHACHHANG.HOTEN
ORDER BY COUNT(HOADON.MAKH) DESC;

-- 40. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT THANG FROM (
	SELECT MONTH(NGHD) THANG, RANK() OVER (ORDER BY SUM(TRIGIA) DESC) RANK_TRIGIA FROM HOADON
	WHERE YEAR(NGHD) = '2006' 
	GROUP BY MONTH(NGHD)
) A
WHERE RANK_TRIGIA = 1;

--41. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT A.MASP, TENSP FROM (
	SELECT MASP, RANK() OVER (ORDER BY SUM(SL)) RANK_SL
	FROM CTHD CT INNER JOIN HOADON HD
	ON CT.SOHD = HD.SOHD
	WHERE YEAR(NGHD) = '2006'
	GROUP BY MASP
) A INNER JOIN SANPHAM SP
ON A.MASP = SP.MASP
WHERE RANK_SL = 1;

-- 42.	*Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT NUOCSX, MASP, TENSP FROM (
	SELECT NUOCSX, MASP, TENSP, GIA, RANK() OVER (PARTITION BY NUOCSX ORDER BY GIA DESC) RANK_GIA FROM SANPHAM
) A 
WHERE RANK_GIA = 1;

-- 43.	Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT NUOCSX FROM SANPHAM 
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3;


-- 44.	*Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
SELECT MAKH, HOTEN FROM (
	SELECT TOP 10 HD.MAKH, HOTEN, DOANHSO, RANK() OVER (ORDER BY COUNT(HD.MAKH) DESC) RANK_SOLAN 
	FROM HOADON HD INNER JOIN KHACHHANG KH 
	ON HD.MAKH = KH.MAKH
	GROUP BY HD.MAKH, HOTEN, DOANHSO
	ORDER BY DOANHSO DESC
) A
WHERE RANK_SOLAN = 1;