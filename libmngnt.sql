DROP DATABASE IF EXISTS library;

CREATE DATABASE library;


USE library;


CREATE TABLE publisher (
    publisher_publisherName VARCHAR(225) PRIMARY KEY,
    publisher_publisherAddress VARCHAR(225),
    publisher_publisherPhone VARCHAR(225)
);


CREATE TABLE book (
    book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    book_Title VARCHAR(225),
    book_publisherName VARCHAR(225) NOT NULL,
    FOREIGN KEY (book_publisherName) REFERENCES publisher(publisher_publisherName)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE book_authors (
    book_authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    book_authors_BookID INT NOT NULL,
    book_authors_AuthorName VARCHAR(225),
    FOREIGN KEY (book_authors_BookID) REFERENCES book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE library_branch (
    library_branch_BranchID INT AUTO_INCREMENT PRIMARY KEY,
    library_branch_BranchName VARCHAR(225),
    library_branch_BranchAddress VARCHAR(225)
);


CREATE TABLE book_borrower (
    borrower_CardNo INT AUTO_INCREMENT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(225),
    borrower_BorrowerAddress VARCHAR(225),
    borrower_BorrowerPhone varchar(225)
);


CREATE TABLE book_copies (
    book_copies_CopiesID INT AUTO_INCREMENT PRIMARY KEY,
    book_copies_BookID INT NOT NULL,
    book_copies_BranchID INT NOT NULL,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (book_copies_BranchID) REFERENCES library_branch(library_branch_BranchID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE book_loans (
    book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY,
    book_loans_BookID INT NOT NULL,
    book_loans_BranchID INT NOT NULL,
    book_loans_CardNo INT NOT NULL,
    book_loans_DateOut varchar(225),
    book_loans_DueDate varchar(225),
    FOREIGN KEY (book_loans_BookID) REFERENCES book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_BranchID) REFERENCES library_branch(library_branch_BranchID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_CardNo) REFERENCES book_borrower(borrower_CardNo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


SELECT book_copies_No_Of_Copies 
FROM book b
INNER JOIN book_copies bc
ON b.book_BookID =  bc.book_copies_BookID
INNER JOIN library_branch lb
ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
AND lb.library_branch_BranchName = 'Sharpstown';


SELECT lb.library_branch_BranchName BranchName , SUM(book_copies_No_Of_Copies) total_copies
FROM book b
JOIN book_copies bc
ON b.book_BookID =  bc.book_copies_BookID 
JOIN library_branch lb
ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
GROUP BY lb.library_branch_BranchName;


SELECT borrower_BorrowerName
FROM book_borrower bb
LEFT JOIN book_loans bl
ON bb.borrower_CardNo = bl.book_loans_CardNo 
WHERE bl.book_loans_CardNo IS NULL;


SELECT b.book_title , bb.borrower_BorrowerName , bb.borrower_BorrowerAddress
FROM book b
JOIN book_loans bl
ON b.book_BookId = bl.book_loans_BookID
JOIN book_borrower bb
ON bl.book_loans_CardNo = bb.Borrower_CardNo
JOIN library_branch lb
ON bl.book_loans_BranchID = lb.library_branch_BranchID
WHERE library_branch_BranchName = 'Sharpstown'
AND book_loans_DueDate = '2/3/18';



SELECT lb.library_branch_BranchName BranchName  , COUNT(bl.book_loans_BranchID) TotalBooks 
FROM book_loans bl
LEFT JOIN library_branch lb
ON bl.book_loans_BranchID = lb.library_branch_BranchID
GROUP BY lb.library_branch_BranchName;


SELECT bb.borrower_BorrowerName , bb.borrower_BorrowerAddress ,COUNT(bl.book_loans_LoansID) AS No_Of_Books_CheckedOut
FROM book_borrower bb
JOIN book_loans bl
ON bl.book_loans_CardNo = bb.borrower_CardNo
GROUP BY bb.borrower_BorrowerName , bb.borrower_BorrowerAddress
HAVING COUNT(bl.book_loans_LoansID)>5;

SELECT b.book_Title , book_copies_No_Of_Copies
FROM book b
JOIN book_authors ba
ON ba.book_authors_BookID = b.book_BookID
JOIN book_copies bc
ON bc.book_copies_BookID = b.book_BookID
JOIN library_branch lb
ON lb.library_branch_BranchID = bc.book_copies_BranchID
WHERE ba.book_authors_AuthorName = 'Stephen King'
AND lb.library_branch_BranchName = 'Central';

