DROP DATABASE IF EXISTS library;

-- create database
CREATE DATABASE library;

-- use database 
USE library;

-- creating tbl_publisher
CREATE TABLE publisher (
    publisher_publisherName VARCHAR(225) PRIMARY KEY,
    publisher_publisherAddress VARCHAR(225),
    publisher_publisherPhone VARCHAR(225)
);

-- creating tbl_book
CREATE TABLE book (
    book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    book_Title VARCHAR(225),
    book_publisherName VARCHAR(225) NOT NULL,
    FOREIGN KEY (book_publisherName) REFERENCES publisher(publisher_publisherName)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- creating tbl_book_authors
CREATE TABLE book_authors (
    book_authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    book_authors_BookID INT NOT NULL,
    book_authors_AuthorName VARCHAR(225),
    FOREIGN KEY (book_authors_BookID) REFERENCES book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- creating tbl_library_branch
CREATE TABLE library_branch (
    library_branch_BranchID INT AUTO_INCREMENT PRIMARY KEY,
    library_branch_BranchName VARCHAR(225),
    library_branch_BranchAddress VARCHAR(225)
);


-- creating tbl_borrower
CREATE TABLE book_borrower (
    borrower_CardNo INT AUTO_INCREMENT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(225),
    borrower_BorrowerAddress VARCHAR(225),
    borrower_BorrowerPhone varchar(225)
);

-- creating tbl_book_copies
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

-- creating tbl_book_loans
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



-- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
-- select * from book_copies;

SELECT book_copies_No_Of_Copies 
FROM book b
INNER JOIN book_copies bc
ON b.book_BookID =  bc.book_copies_BookID
INNER JOIN library_branch lb
ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
AND lb.library_branch_BranchName = 'Sharpstown';



-- How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT lb.library_branch_BranchName BranchName , SUM(book_copies_No_Of_Copies) total_copies
FROM book b
JOIN book_copies bc
ON b.book_BookID =  bc.book_copies_BookID 
JOIN library_branch lb
ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
GROUP BY lb.library_branch_BranchName;


-- Retrieve the names of all borrowers who do not have any books checked out.
SELECT borrower_BorrowerName
FROM book_borrower bb
LEFT JOIN book_loans bl
ON bb.borrower_CardNo = bl.book_loans_CardNo 
WHERE bl.book_loans_CardNo IS NULL;

-- For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
-- retrieve the book title, the borrower's name, and the borrower's address. 

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


-- For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

SELECT lb.library_branch_BranchName BranchName  , COUNT(bl.book_loans_BranchID) TotalBooks 
FROM book_loans bl
LEFT JOIN library_branch lb
ON bl.book_loans_BranchID = lb.library_branch_BranchID
GROUP BY lb.library_branch_BranchName;



-- Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

SELECT bb.borrower_BorrowerName , bb.borrower_BorrowerAddress ,COUNT(bl.book_loans_LoansID) AS No_Of_Books_CheckedOut
FROM book_borrower bb
JOIN book_loans bl
ON bl.book_loans_CardNo = bb.borrower_CardNo
GROUP BY bb.borrower_BorrowerName , bb.borrower_BorrowerAddress
HAVING COUNT(bl.book_loans_LoansID)>5;

-- For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

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

