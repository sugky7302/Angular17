// import Image from 'next/image';
import Sidebar from './sidebar';

export default function App() {
    return (
        <main className="min-h-screen">
            {/* <Image
                src="https://i.imgur.com/MK3eW3Am.jpg"
                width={500}
                height={500}
                alt="Katherine Johnson"
            /> */}
            <Sidebar />
        </main>
    );
}
