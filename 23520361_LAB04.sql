-- 76. Liệt kê top 3 chuyên gia có nhiều kỹ năng nhất và số lượng kỹ năng của họ.
SELECT TOP 3 CHUYENGIA.MaChuyenGia, CHUYENGIA.HoTen, COUNT( ChuyenGia_KyNang.MaKyNang) AS SLKN
FROM CHUYENGIA
JOIN ChuyenGia_KyNang ON CHUYENGIA.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
GROUP BY CHUYENGIA.HoTen, CHUYENGIA.MaChuyenGia
ORDER BY SLKN DESC;

-- 77. Tìm các cặp chuyên gia có cùng chuyên ngành và số năm kinh nghiệm chênh lệch không quá 2 năm.
SELECT CG1.MACHUYENGIA AS MACHUYENGIA1, CG1.HOTEN AS HOTEN1, CG2.MACHUYENGIA AS MACHUYENGIA2, CG2.HOTEN AS HOTEN2
FROM CHUYENGIA CG1
JOIN CHUYENGIA CG2 ON CG1.MaChuyenGia = CG2.MaChuyenGia
WHERE CG1.ChuyenNganh = CG2.ChuyenNganh
AND ABS(CG1.NamKinhNghiem - CG2.NamKinhNghiem) <=2
ORDER BY CG1.ChuyenNganh, CG1.HoTen, CG2.HoTen

-- 78. Hiển thị tên công ty, số lượng dự án và tổng số năm kinh nghiệm của các chuyên gia tham gia dự án của công ty đó.
SELECT CongTy.TenCongTy, COUNT( DuAn.MaCongTy) AS SLDA, SUM( CHUYENGIA.NamKinhNghiem) AS TONGNAMKINHNGHIEM
FROM CongTy
LEFT JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
LEFT JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
LEFT JOIN CHUYENGIA ON ChuyenGia_DuAn.MaChuyenGia = CHUYENGIA.MaChuyenGia
GROUP BY CongTy.TenCongTy;

-- 79. Tìm các chuyên gia có ít nhất một kỹ năng cấp độ 5 nhưng không có kỹ năng nào dưới cấp độ 3.
SELECT CHUYENGIA.MaChuyenGia, CHUYENGIA.HoTen, COUNT( ChuyenGia_KyNang.CAPDO) AS SLKN
FROM CHUYENGIA
JOIN ChuyenGia_KyNang ON CHUYENGIA.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
WHERE CHUYENGIA_KYNANG.CAPDO = 5 
AND NOT ChuyenGia_KyNang.CapDo <3
GROUP BY CHUYENGIA.MaChuyenGia, CHUYENGIA.HoTen;

-- 80. Liệt kê các chuyên gia và số lượng dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào.
SELECT CHUYENGIA.MaChuyenGia, CHUYENGIA.HoTen, COUNT( ChuyenGia_DuAn.MaDuAn) AS SLDA
FROM CHUYENGIA
LEFT JOIN ChuyenGia_DuAn ON CHUYENGIA.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
GROUP BY CHUYENGIA.MaChuyenGia, CHUYENGIA.HoTen;

-- 81*. Tìm chuyên gia có kỹ năng ở cấp độ cao nhất trong mỗi loại kỹ năng.
WITH MaxCapDo AS (
    SELECT 
        MaKyNang,
        MAX(CapDo) AS CapDoCaoNhat
    FROM 
        ChuyenGia_KyNang
    GROUP BY 
        MaKyNang
)
SELECT 
    cg.HoTen,
    ky.TenKyNang,
    cgk.CapDo
FROM 
    ChuyenGia_KyNang cgk
JOIN 
    MaxCapDo mc ON cgk.MaKyNang = mc.MaKyNang AND cgk.CapDo = mc.CapDoCaoNhat
JOIN 
    ChuyenGia cg ON cgk.MaChuyenGia = cg.MaChuyenGia
JOIN 
    KyNang ky ON cgk.MaKyNang = ky.MaKyNang
ORDER BY 
    ky.TenKyNang, cg.HoTen;


-- 82. Tính tỷ lệ phần trăm của mỗi chuyên ngành trong tổng số chuyên gia.
SELECT 
    ChuyenNganh,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ChuyenGia), 2) AS TyLePhanTram
FROM 
    ChuyenGia
GROUP BY 
    ChuyenNganh
ORDER BY 
    ChuyenNganh;


-- 83. Tìm các cặp kỹ năng thường xuất hiện cùng nhau nhất trong hồ sơ của các chuyên gia.
WITH SkillPairs AS (
    SELECT 
        a.MaKyNang AS Skill1,
        b.MaKyNang AS Skill2,
        COUNT(*) AS PairCount
    FROM 
        ChuyenGia_KyNang a
    JOIN 
        ChuyenGia_KyNang b ON a.MaChuyenGia = b.MaChuyenGia AND a.MaKyNang < b.MaKyNang
    GROUP BY 
        a.MaKyNang, b.MaKyNang
)

SELECT 
    k1.TenKyNang AS Skill1,
    k2.TenKyNang AS Skill2,
    sp.PairCount
FROM 
    SkillPairs sp
JOIN 
    KyNang k1 ON sp.Skill1 = k1.MaKyNang
JOIN 
    KyNang k2 ON sp.Skill2 = k2.MaKyNang
ORDER BY 
    sp.PairCount DESC;

-- 84. Tính số ngày trung bình giữa ngày bắt đầu và ngày kết thúc của các dự án cho mỗi công ty.
SELECT 
    c.TenCongTy AS CompanyName,
    AVG(DATEDIFF(DAY, d.NgayBatDau, d.NgayKetThuc)) AS AverageDays
FROM 
    DuAn d
JOIN 
    CongTy c ON d.MaCongTy = c.MaCongTy
GROUP BY 
    c.TenCongTy;


-- 85*. Tìm chuyên gia có sự kết hợp độc đáo nhất của các kỹ năng (kỹ năng mà chỉ họ có).
WITH UniqueSkills AS (
    SELECT 
        ck.MaChuyenGia,
        k.TenKyNang,
        COUNT(*) OVER (PARTITION BY k.MaKyNang) AS SkillCount
    FROM 
        ChuyenGia_KyNang ck
    JOIN 
        KyNang k ON ck.MaKyNang = k.MaKyNang
)

SELECT 
    us.MaChuyenGia,
    cg.HoTen,
    STRING_AGG(us.TenKyNang, ', ') AS UniqueSkills
FROM 
    UniqueSkills us
JOIN 
    ChuyenGia cg ON us.MaChuyenGia = cg.MaChuyenGia
WHERE 
    us.SkillCount = 1
GROUP BY 
    us.MaChuyenGia, cg.HoTen
ORDER BY 
    cg.HoTen;


-- 86*. Tạo một bảng xếp hạng các chuyên gia dựa trên số lượng dự án và tổng cấp độ kỹ năng.
WITH ExpertProjects AS (
    SELECT 
        cgd.MaChuyenGia,
        COUNT(DISTINCT cgd.MaDuAn) AS ProjectCount
    FROM 
        ChuyenGia_DuAn cgd
    GROUP BY 
        cgd.MaChuyenGia
),
ExpertSkills AS (
    SELECT 
        ck.MaChuyenGia,
        SUM(ck.CapDo) AS TotalSkillLevel
    FROM 
        ChuyenGia_KyNang ck
    GROUP BY 
        ck.MaChuyenGia
)

SELECT 
    cg.MaChuyenGia,
    cg.HoTen,
    COALESCE(ep.ProjectCount, 0) AS ProjectCount,
    COALESCE(es.TotalSkillLevel, 0) AS TotalSkillLevel,
    (COALESCE(ep.ProjectCount, 0) + COALESCE(es.TotalSkillLevel, 0)) AS TotalScore,
    RANK() OVER (ORDER BY (COALESCE(ep.ProjectCount, 0) + COALESCE(es.TotalSkillLevel, 0)) DESC) AS Rank
FROM 
    ChuyenGia cg
LEFT JOIN 
    ExpertProjects ep ON cg.MaChuyenGia = ep.MaChuyenGia
LEFT JOIN 
    ExpertSkills es ON cg.MaChuyenGia = es.MaChuyenGia
ORDER BY 
    Rank;


-- 87. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
SELECT 
    d.MaDuAn,
    d.TenDuAn
FROM 
    DuAn d
JOIN 
    ChuyenGia_DuAn cgd ON d.MaDuAn = cgd.MaDuAn
JOIN 
    ChuyenGia cg ON cgd.MaChuyenGia = cg.MaChuyenGia
GROUP BY 
    d.MaDuAn, d.TenDuAn
HAVING 
    COUNT(DISTINCT cg.ChuyenNganh) = (SELECT COUNT(DISTINCT ChuyenNganh) FROM ChuyenGia);


-- 88. Tính tỷ lệ thành công của mỗi công ty dựa trên số dự án hoàn thành so với tổng số dự án.
SELECT 
    c.MaCongTy,
    c.TenCongTy,
    COUNT(d.MaDuAn) AS TotalProjects,
    COUNT(CASE WHEN d.TrangThai = N'Hoàn thành' THEN 1 END) AS CompletedProjects,
    CASE 
        WHEN COUNT(d.MaDuAn) = 0 THEN 0
        ELSE (COUNT(CASE WHEN d.TrangThai = N'Hoàn thành' THEN 1 END) * 100.0 / COUNT(d.MaDuAn))
    END AS SuccessRate
FROM 
    CongTy c
LEFT JOIN 
    DuAn d ON c.MaCongTy = d.MaCongTy
GROUP BY 
    c.MaCongTy, c.TenCongTy;


-- 89. Tìm các chuyên gia có kỹ năng "bù trừ" nhau (một người giỏi kỹ năng A nhưng yếu kỹ năng B, người kia ngược lại).
WITH SkillLevels AS (
    SELECT 
        cg.MaChuyenGia,
        k.TenKyNang,
        ck.CapDo
    FROM 
        ChuyenGia_KyNang ck
    JOIN 
        ChuyenGia cg ON ck.MaChuyenGia = cg.MaChuyenGia
    JOIN 
        KyNang k ON ck.MaKyNang = k.MaKyNang
)

SELECT 
    s1.MaChuyenGia AS Expert1,
    s2.MaChuyenGia AS Expert2,
    s1.TenKyNang AS SkillA,
    s1.CapDo AS LevelA,
    s2.CapDo AS LevelB
FROM 
    SkillLevels s1
JOIN 
    SkillLevels s2 ON s1.TenKyNang = s2.TenKyNang 
WHERE 
    s1.MaChuyenGia <> s2.MaChuyenGia AND
    s1.CapDo >= 4 AND  -- Assuming level 4 and above is considered strong
    s2.CapDo <= 3     -- Assuming level 3 and below is considered weak
ORDER BY 
    Expert1, Expert2;
