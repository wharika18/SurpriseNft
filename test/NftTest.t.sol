//SPDX License-Identifier : MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {SurpriseNft} from "../../src/SurpriseNft.sol";
import {Surprise} from "../src/enum.sol";

contract NftTest is Test {
    SurpriseNft surpriseNft;

    string public constant CAR_SVG_URI =
        "data:image/vg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCg0KPCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4NCjwhLS0gVXBsb2FkZWQgdG86IFNWRyBSZXBvLCB3d3cuc3ZncmVwby5jb20sIEdlbmVyYXRvcjogU1ZHIFJlcG8gTWl4ZXIgVG9vbHMgLS0+DQo8c3ZnIHZlcnNpb249IjEuMSIgaWQ9Il94MzJfIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiANCgkgd2lkdGg9IjgwMHB4IiBoZWlnaHQ9IjgwMHB4IiB2aWV3Qm94PSIwIDAgNTEyIDUxMiIgIHhtbDpzcGFjZT0icHJlc2VydmUiPg0KPHN0eWxlIHR5cGU9InRleHQvY3NzIj4NCjwhW0NEQVRBWw0KCS5zdDB7ZmlsbDojMDAwMDAwO30NCl1dPg0KPC9zdHlsZT4NCjxnPg0KCTxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik0zNjAuODE5LDI4Mi4wMTZjLTExLjY3Mi0wLjAxNi0yMi4zNTksNC43NS0yOS45ODQsMTIuNDA2Yy03LjY1Niw3LjYyNS0xMi40MjIsMTguMzEzLTEyLjQyMiwyOS45ODQNCgkJYzAuMDE2LDIzLjQwNiwxOC45NjksNDIuMzc1LDQyLjQwNiw0Mi4zNzVjMjMuNDIyLDAsNDIuMzc1LTE4Ljk4NCw0Mi4zNzUtNDIuMzc1YzAuMDE2LTExLjY3Mi00Ljc1LTIyLjM1OS0xMi4zOTEtMjkuOTg0DQoJCUMzODMuMTYzLDI4Ni43NjYsMzcyLjQ3NSwyODIsMzYwLjgxOSwyODIuMDE2eiBNMzYwLjgxOSwzNDUuNDg0Yy0xMS42NzItMC4wMTYtMjEuMDc4LTkuNDUzLTIxLjA5NC0yMS4wNzgNCgkJYzAtMTEuNjcyLDkuNDA2LTIxLjA5NCwyMS4wOTQtMjEuMDk0YzExLjY1NiwwLDIxLjA3OCw5LjQyMiwyMS4wNzgsMjEuMDk0QzM4MS44ODEsMzM2LjAzMSwzNzIuNDU5LDM0NS40NjksMzYwLjgxOSwzNDUuNDg0eiIvPg0KCTxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik0xMjYuNjE2LDI4Mi4wMTZjLTExLjY4OC0wLjAxNi0yMi4zNDQsNC43NS0yOS45ODQsMTIuNDA2Yy03LjY1Niw3LjYyNS0xMi40MDYsMTguMzEzLTEyLjQwNiwyOS45ODQNCgkJYzAuMDE2LDIzLjM5MSwxOC45NTMsNDIuMzc1LDQyLjM5MSw0Mi4zNzVjMjMuNDIyLDAsNDIuMzkxLTE4Ljk2OSw0Mi4zOTEtNDIuMzc1QzE2OS4wMDYsMzAwLjk1MywxNTAuMDIyLDI4Mi4wMTYsMTI2LjYxNiwyODIuMDE2DQoJCXogTTEyNi42MTYsMzQ1LjQ4NGMtMTEuNjcyLTAuMDE2LTIxLjA2My05LjQ1My0yMS4wNzgtMjEuMDc4YzAtMTEuNjcyLDkuNDA2LTIxLjA5NCwyMS4wNzgtMjEuMDk0DQoJCWMxMS42NTYsMC4wMTYsMjEuMDc4LDkuNDIyLDIxLjA5NCwyMS4wOTRDMTQ3LjY5NCwzMzYuMDMxLDEzOC4yNTYsMzQ1LjQ2OSwxMjYuNjE2LDM0NS40ODR6Ii8+DQoJPHBhdGggY2xhc3M9InN0MCIgZD0iTTUwNy45NzYsMjI2LjE3MmMtMy4yNS0zLjc4MS03Ljk4NC01Ljk4NC0xMi45NTMtNS45ODRoLTEwNC4xMWMtNi41NDcsMC0xMi43MTktMy4wMTYtMTYuNzM0LTguMTU2DQoJCWwtNDUuODc1LTU4LjY1NmMtNC4wMzEtNS4xNDEtMTAuMjAzLTguMTU2LTE2LjczNC04LjE1NkgxNDUuMzM0Yy03LjYwOSwwLTE0LjYyNSw0LjA3OC0xOC40MjIsMTAuNjU2bC0zNi45NTMsNjQuMzEzSDE2Ljk5MQ0KCQljLTUuMDE2LDAtOS43OTcsMi4yMTktMTMuMDE2LDYuMDYzcy00LjU5NCw4LjkzOC0zLjcxOSwxMy44NTlsNi45NjksNjQuNWMxLjE3MiwxMC43NjYsMTAuMjM0LDE4Ljk1MywyMS4wNzgsMTguOTY5bDQ3LjcxOSwwLjEwOQ0KCQl2LTE0Ljk4NGwtNDcuNjcyLTAuMTA5Yy0zLjIwMy0wLjAxNi01Ljg3NS0yLjQwNi02LjIxOS01LjU5NGwtNy4xMjUtNjUuNDg0bDAuNDUzLTEuNjQxbDEuNTMxLTAuNjg4aDcyLjk2OQ0KCQljNS4zNzUsMCwxMC4zMTMtMi44NzUsMTMuMDE2LTcuNTMxbDM2LjkzOC02NC4yOTdjMS4xMDktMS45NTMsMy4xODgtMy4xNDEsNS40MjItMy4xNDFoMTY2LjIzNGMxLjg5MSwwLDMuNzUsMC44OTEsNC45MjIsMi4zOTENCgkJbDQ1Ljg3NSw1OC42ODhjNi45MzgsOC44MTMsMTcuMzI4LDEzLjg5MSwyOC41NDcsMTMuODkxaDEwNC4xMWwxLjUzMSwwLjY4OGwwLjUxNiwwLjY3MmwwLjE3Mi0wLjI5N2wtMTcuNjI1LDY4LjY4OA0KCQljLTAuNjcyLDIuNzY2LTMuMTg4LDQuNzAzLTYuMDYzLDQuNzAzbC02Mi4xNzItMC4xMjVWMzI0LjVsNjIuMTQxLDAuMTQxYzkuNzM0LDAsMTguMjAzLTYuNTYzLDIwLjYyNS0xNS45ODRsMTcuNjQxLTY4LjczNA0KCQlDNTEyLjU2OSwyMzUsNTExLjE5NCwyMjkuOTY5LDUwNy45NzYsMjI2LjE3MnoiLz4NCgk8cG9seWdvbiBjbGFzcz0ic3QwIiBwb2ludHM9IjE3Ny4yMDksMzIzLjg5MSAzMTAuMjI1LDMyNC4yODEgMzEwLjIyNSwzMDkuMjk3IDE3Ny4yMDksMzA4LjkyMiAJIi8+DQo8L2c+DQo8L3N2Zz4=";

    string public constant MOTORBIKE_SVG_URI =
        "data:image/vg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEtLSBVcGxvYWRlZCB0bzogU1ZHIFJlcG8sIHd3dy5zdmdyZXBvLmNvbSwgR2VuZXJhdG9yOiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4NCjxzdmcgZmlsbD0iIzAwMDAwMCIgaGVpZ2h0PSI4MDBweCIgd2lkdGg9IjgwMHB4IiB2ZXJzaW9uPSIxLjEiIGlkPSJDYXBhXzEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIA0KCSB2aWV3Qm94PSIwIDAgNDkwIDQ5MCIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSI+DQo8cGF0aCBkPSJNMzU3Ljc2Nyw0MC43MDljLTAuMjA4LDYuODQ4LDIuNjkzLDEyLjg2Myw3LjM3MSwxOC4wMTlsLTM5LjE5MSwxNy4zOTFjLTMuMTQxLTAuNjUxLTYuMzY1LTAuOTk3LTkuNjQ4LTAuOTk3SDE3My43MDENCgljLTIuMzQ2LDAtNC42NTksMC4xODUtNi45MzcsMC41MTlsLTM3LjYwOC0xNi42ODhjNC44MDUtNS4yMDUsNy41NzctMTEuMjkyLDcuNTc3LTE4LjI0M0MxMzYuNzMzLDEzLjk4NCw5NS44MzUsMCw1NS40MjYsMA0KCUMyMi44ODUsMCwwLDkuOTI3LDAsOS45Mjd2NjEuNTY2YzAsMCwyMi4xMzgsOS45MjYsNTUuNDI2LDkuOTI2YzE4Ljg1LDAsMzcuODA1LTMuMDQ0LDUyLjY2Ny05LjAwNGwzMy43OCwxNC45OQ0KCWMtMS42MTUsMS40NC0yMi4wMTYsMTcuODI2LTE3Ljc5Niw0OS41MjdsMzAuMzgxLDIyNi41NjJjMy4xNTQsMjMuNTEyLDIwLjQwOCw0MS44NjEsNDEuNjIxLDQ1LjYwOHYzMS45NjcNCgljMCwyNi45OCwyMS45NSw0OC45MzEsNDguOTIxLDQ4LjkzMWMyNi45OCwwLDQ4LjkzLTIxLjk1MSw0OC45My00OC45MzF2LTMxLjk2OGMyMS4yMDktMy43NTEsMzguNDY3LTIyLjA5OSw0MS42MjEtNDUuNjA3DQoJbDMwLjM4MS0yMjYuNTYyYzIuMTk5LTE2LjQzMi0yLjQ0Ni0zMy44LTE2LjU2Ni00OC4zOTdsMzYuNjY2LTE2LjI3YzE0LjkxNyw2LjA1OSwzNC4wMzIsOS4xNTUsNTMuMDQxLDkuMTU1DQoJYzI1LjY0MiwwLDUwLjkyNy04LjEwNCw1MC45MjctOC4xMDRWOC4xMDRDNDU5LjQ0OC02LjAyMiwzNTkuMTE1LTMuNzY0LDM1Ny43NjcsNDAuNzA5eiBNMjAuODUxLDU2LjM5OFYyNS4wMg0KCWMxMC4yNTMtMi43MDgsMjIuMjU1LTQuMTY5LDM0LjU3NS00LjE2OWMzNy41MDcsMCw2MC40NTYsMTIuODU5LDYwLjQ1NiwxOS44NThjMCw3LTIyLjk0OSwxOS44NTktNjAuNDU2LDE5Ljg1OQ0KCUM0My4xMDcsNjAuNTY4LDMxLjEwNCw1OS4xMDcsMjAuODUxLDU2LjM5OHogTTMxNi4yOTgsOTUuOTczYzIyLjk1OCwwLDMxLjM1MywyNC45MDEsMjguOTY2LDM4LjE5bC03LjYzNSw1Ni45MzhoLTQwLjExMQ0KCWMtNC41Ni0yNi44MjgtMjYuMzY0LTQ3LjIyNS01Mi41MTktNDcuMjI1Yy0yNi4xNDcsMC00Ny45NDksMjAuMzk3LTUyLjUwOSw0Ny4yMjVoLTQwLjExbC03LjYzNS01Ni45MzgNCgljLTEuOTk1LTE1Ljc2OCw3LjE2My0zOC4xOSwyOC45NTUtMzguMTlIMzE2LjI5OHogTTI3Ny41NTksMjAxLjUyNmMwLDIwLjI5MS0xNC42MSwzNi43OTUtMzIuNTU5LDM2Ljc5NQ0KCWMtMTcuOTUsMC0zMi41NDktMTYuNTA0LTMyLjU0OS0zNi43OTVjMC0yMC4yOTEsMTQuNi0zNi44LDMyLjU0OS0zNi44QzI2Mi45NDksMTY0LjcyNiwyNzcuNTU5LDE4MS4yMzUsMjc3LjU1OSwyMDEuNTI2eg0KCSBNMjczLjA3OSw0NDEuMDY5YzAsMTUuNDg1LTEyLjU5NCwyOC4wOC0yOC4wNzksMjguMDhjLTE1LjQ3NiwwLTI4LjA3LTEyLjU5NS0yOC4wNy0yOC4wOFYzNTcuNzENCgljMC0xNS40ODYsMTIuNTk0LTI4LjA4LDI4LjA3LTI4LjA4YzE1LjQ4NSwwLDI4LjA3OSwxMi41OTQsMjguMDc5LDI4LjA4VjQ0MS4wNjl6IE0zMTQuODgzLDM2MC43MjUNCgljLTEuNzQzLDEzLjAwNC0xMC4yMDIsMjMuNDItMjAuOTUzLDI2Ljk0OFYzNTcuNzFjMC0yNi45OC0yMS45NS00OC45MzEtNDguOTMtNDguOTMxYy0yNi45NzEsMC00OC45MjEsMjEuOTUxLTQ4LjkyMSw0OC45MzF2MjkuOTY0DQoJYy0xMC43NDktMy41MjYtMTkuMjEtMTMuOTQ0LTIwLjk1My0yNi45NWwtMTkuOTQ5LTE0OC43NzNoMzcuMzE0YzQuNTYsMjYuODI0LDI2LjM2Myw0Ny4yMiw1Mi41MDksNDcuMjINCgljMjYuMTU1LDAsNDcuOTU4LTIwLjM5Niw1Mi41MTgtNDcuMjJoMzcuMzE1TDMxNC44ODMsMzYwLjcyNXogTTQ2OS4xNDksNTcuNDc4Yy05LjIyNSwyLjAzMi0xOS40NjcsMy4wOS0zMC4wNzYsMy4wOQ0KCWMtMzcuNTA4LDAtNjAuNDU2LTEyLjg1OS02MC40NTYtMTkuODU5YzAtNi45OTksMjIuOTQ3LTE5Ljg1OCw2MC40NTYtMTkuODU4YzEwLjYwOSwwLDIwLjg1MSwxLjA1OSwzMC4wNzYsMy4wOVY1Ny40Nzh6Ii8+DQo8L3N2Zz4=";

    address USER = makeAddr("user");

    function setUp() public {
        surpriseNft = new SurpriseNft(CAR_SVG_URI, MOTORBIKE_SVG_URI);
    }

    function testViewTokenURI() public {
        vm.prank(USER);
        surpriseNft.mintNft();
        console.log(surpriseNft.tokenURI(1));
    }

    function testSurprise() public {
        vm.prank(USER);
        surpriseNft.mintNft();

        bool isExpectedSurprise = surpriseNft.getSurpriseWithTokenId(1) ==
            Surprise.MOTORBIKE;
        assertEq(isExpectedSurprise, true);
    }

    function testFlip(uint256 tokenId) public {
        vm.prank(USER);
        surpriseNft.flipSurpriseForLucky(5);
        bool isExpectedSurprise = surpriseNft.getSurpriseWithTokenId(5) ==
            Surprise.CAR;
        assertEq(isExpectedSurprise, true);
    }
}
